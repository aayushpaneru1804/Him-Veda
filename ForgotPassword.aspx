<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="HimVeda.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Forgot Password
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <h2 class="text-center mb-4" style="margin-bottom: 2rem;">Forgot Password</h2>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="text-center mb-4" style="display:block; margin-bottom: 1rem;" BackColor="#fee2e2" ForeColor="#ef4444" Visible="false"></asp:Label>

        <asp:Panel ID="pnlStep1" runat="server">
            <p style="text-align: center; margin-bottom: 1.5rem; color: var(--text-muted);">
                Enter your registered Email to recover your password.
            </p>
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="your@email.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="Step1Group"></asp:RequiredFieldValidator>
            </div>

            <asp:Button ID="btnNext" runat="server" Text="Next" CssClass="btn btn-primary" style="width: 100%; padding: 0.8rem;" OnClick="btnNext_Click" ValidationGroup="Step1Group" />
        </asp:Panel>

        <asp:Panel ID="pnlStep2" runat="server" Visible="false">
            <p style="text-align: center; margin-bottom: 1.5rem; color: var(--text-muted);">
                Please answer your security question and verify your date of birth.
            </p>
            
            <div class="form-group" style="padding: 1rem; background: #f8fafc; border-radius: 8px; border: 1px solid #e2e8f0; margin-bottom: 1.5rem;">
                <label class="form-label" style="font-weight: 700;">Security Question:</label>
                <div style="font-size: 1.1rem; color: var(--primary-color);">
                    <asp:Label ID="lblSecurityQuestion" runat="server" Text=""></asp:Label>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Security Answer</label>
                <asp:TextBox ID="txtSecurityAnswer" runat="server" CssClass="form-control" placeholder="Enter your secret answer"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSecurityAnswer" runat="server" ControlToValidate="txtSecurityAnswer" ErrorMessage="Security Answer is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="Step2Group"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Date of Birth</label>
                <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDOB" runat="server" ControlToValidate="txtDOB" ErrorMessage="Date of Birth is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="Step2Group"></asp:RequiredFieldValidator>
            </div>

            <asp:Button ID="btnVerify" runat="server" Text="Verify" CssClass="btn btn-primary" style="width: 100%; padding: 0.8rem;" OnClick="btnVerify_Click" ValidationGroup="Step2Group" />
            
            <div style="text-align: center; margin-top: 1rem;">
                <asp:LinkButton ID="lnkBack" runat="server" OnClick="lnkBack_Click" style="font-size: 0.9rem; color: var(--primary-color); font-weight: 600;">&larr; Back</asp:LinkButton>
            </div>
        </asp:Panel>

        <p class="text-center mt-2" style="margin-top: 1.5rem;">
            Remember your password? <a href="Login.aspx" style="font-weight: 600;">Sign in here</a>
        </p>
    </div>
</asp:Content>
