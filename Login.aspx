<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HimVeda.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Login
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <h2 class="text-center mb-4" style="margin-bottom: 2rem;">Welcome Back</h2>
        
        <asp:Label ID="lblError" runat="server" CssClass="text-center mb-4" style="display:block; margin-bottom: 1rem;" BackColor="#fee2e2" ForeColor="#ef4444" Visible="false"></asp:Label>

        <div class="form-group">
            <label class="form-label">Email Address</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="your@email.com"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Please enter a valid email." CssClass="validator-error" Display="Dynamic" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"></asp:RegularExpressionValidator>
        </div>
        <div class="form-group">
            <label class="form-label">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div style="text-align: right; margin-bottom: 1.5rem; margin-top: -0.5rem;">
            <a href="ForgotPassword.aspx" style="font-size: 0.9rem; color: var(--primary-color); font-weight: 600;">Forgot Password?</a>
        </div>

        <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary" style="width: 100%; padding: 0.8rem;" OnClick="btnLogin_Click" />
        
        <p class="text-center mt-2" style="margin-top: 1.5rem;">
            Don't have an account? <a href="Register.aspx" style="font-weight: 600;">Register here</a>
        </p>
    </div>
</asp:Content>
