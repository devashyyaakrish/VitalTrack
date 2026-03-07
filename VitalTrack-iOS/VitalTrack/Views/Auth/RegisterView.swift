import SwiftUI

public struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    
    @Binding var showRegister: Bool
    
    public init(showRegister: Binding<Bool>) {
        self._showRegister = showRegister
    }
    
    public var body: some View {
        GradientBackground {
            VStack {
                HStack {
                    Button(action: { showRegister = false }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .glassEffect(cornerRadius: 16)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Create Account")
                        .heading(font: Typography.displayMedium)
                    Text("Join VitalTrack today")
                        .textSecondary()
                }
                
                Spacer().frame(height: 32)
                
                GlassCard {
                    VStack(spacing: 16) {
                        GlassTextField(placeholder: "Full Name", text: $name, icon: "person")
                        GlassTextField(placeholder: "Email Address", text: $email, icon: "envelope")
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        
                        GlassTextField(placeholder: "Password", text: $password, icon: "lock", isSecure: true)
                            .textContentType(.newPassword)
                        GlassTextField(placeholder: "Confirm Password", text: $confirmPassword, icon: "lock.fill", isSecure: true)
                            .textContentType(.newPassword)
                        
                        Button(action: handleRegister) {
                            if isLoading {
                                AnimatedLoader(color: .white)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Sign Up")
                            }
                        }
                        .glassStyle()
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    private func handleRegister() {
        guard !name.isEmpty, !email.isEmpty else { return }
        withAnimation { isLoading = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isLoading = false
            }
            // Navigate away in real app, mocked by closing the sheet here
            showRegister = false
        }
    }
}
