import SwiftUI

public struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    // Binding to handle mock navigation up the view tree hierarchy
    @Binding var isAuthenticated: Bool
    // Optional navigation binding to switch to register sheet
    @Binding var showRegister: Bool
    
    public init(isAuthenticated: Binding<Bool>, showRegister: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
        self._showRegister = showRegister
    }
    
    public var body: some View {
        GradientBackground {
            VStack {
                Spacer()
                
                // Welcome Text
                Text("Welcome Back")
                    .heading(font: Typography.displayMedium)
                    .padding(.bottom, 8)
                Text("Your daily health, beautifully tracked.")
                    .textSecondary()
                
                Spacer().frame(height: 48)
                
                // Form Card
                GlassCard {
                    VStack(spacing: 20) {
                        GlassTextField(
                            placeholder: "Email Address",
                            text: $email,
                            icon: "envelope"
                        )
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        
                        GlassTextField(
                            placeholder: "Password",
                            text: $password,
                            icon: "lock",
                            isSecure: true
                        )
                        .textContentType(.password)
                        
                        HStack {
                            Spacer()
                            Button("Forgot password?") {
                                // Action omitted for mockup
                            }
                            .font(Typography.labelMedium)
                            .foregroundColor(.secondaryAccent)
                        }
                        
                        Button(action: handleLogin) {
                            if isLoading {
                                AnimatedLoader(color: .white)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Sign In")
                            }
                        }
                        .glassStyle()
                        .padding(.top, 16)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer().frame(height: 32)
                
                HStack(spacing: 24) {
                    VStack { Divider().background(Color.glassBorder) }
                    Text("or continue with")
                        .font(Typography.labelSmall)
                        .foregroundColor(.textTertiary)
                    VStack { Divider().background(Color.glassBorder) }
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 24)
                
                Button(action: {
                    handleLogin()
                }) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                        Text("Google")
                    }
                }
                .glassOutlineStyle()
                .padding(.horizontal, 24)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .textSecondary(font: Typography.bodyMedium)
                    Button("Sign Up") {
                        showRegister = true
                    }
                    .font(Typography.bodyMedium)
                    .foregroundColor(.primaryButton)
                    .fontWeight(.bold)
                }
                .padding(.bottom, 32)
            }
        }
    }
    
    // Mock login action
    private func handleLogin() {
        withAnimation { isLoading = true }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isLoading = false
                isAuthenticated = true
            }
        }
    }
}
