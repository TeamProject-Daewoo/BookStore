package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
    @Autowired
    @Qualifier("loginService")
    private UserDetailsService loginService;
    
    @Autowired
    private CustomLogoutHandler customLogoutHandler;

    // XML의 <security:http> 태그 전체를 이 메서드 하나로 설정합니다.
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 1. URL 접근 권한 설정 (XML의 <intercept-url>)
            // CSRF 보호는 기본으로 활성화되므로 로그인 폼에 토큰을 추가해야 합니다.
            .authorizeHttpRequests(authorize -> authorize
            		.antMatchers("/user/**", "/board/main/**", "/board/view/**", "/logout","/resources/**","/cart/**","/category/**","/bestseller/**").permitAll()
                .antMatchers("/purchase/**", "/cart/**", "/board/write/**", "/board/edit/**", "/board/delete/**").hasAnyRole("USER", "ADMIN")
                .antMatchers("/manager/**").hasRole("ADMIN")
                .anyRequest().authenticated() // 나머지 모든 요청은 인증 필요
            )
            // 2. 로그인 설정 (XML의 <form-login>)
            .formLogin(form -> form
                .loginPage("/user/loginform")
                .loginProcessingUrl("/login")
                .usernameParameter("user_id")
                .passwordParameter("password")
                .successHandler(loginSuccessHandler()) // 로그인 성공 시 처리
                .failureUrl("/user/login?error=true")
                .defaultSuccessUrl("/user/booklist", true)
            )
            // 3. 로그아웃 설정 (XML의 <logout>)
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/user/booklist")
                .addLogoutHandler(customLogoutHandler)
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
            )
            // 4. 예외 및 접근 거부 처리
            .exceptionHandling(ex -> ex
                // 접근 거부 처리 (XML의 <access-denied-handler>)
                .accessDeniedHandler(accessDeniedHandler())
                // 인증되지 않은 사용자 처리 (XML의 <http-basic entry-point-ref>)
                .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/user/loginform"))
            );

        return http.build();
    }
    
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        // 사용할 UserDetailsService를 'loginService'로 고정합니다.
        provider.setUserDetailsService(loginService);
        // 사용할 비밀번호 인코더를 설정합니다.
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    // --- XML의 <bean> 및 <authentication-manager> 설정 ---

    // 1. 비밀번호 암호화 Bean (XML의 <bean id="bpe">)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // 2. 로그인 성공 핸들러 Bean (XML의 <bean id="loginSuccess">)
    @Bean
    public AuthenticationSuccessHandler loginSuccessHandler() {
        return new CustomerLoginSuccessHandler();
    }

    // 3. 접근 거부 핸들러 Bean (XML의 <bean id="accessDenied">)
    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return new CustomerLoginDeniedHandler();
    }
    @Bean
    public HttpFirewall allowSemicolonHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        
        // 기본적으로 엄격한 검사를 유지하되, 세미콜론을 허용 목록에 추가
        firewall.setAllowSemicolon(true); 
        
        return firewall;
    }
}