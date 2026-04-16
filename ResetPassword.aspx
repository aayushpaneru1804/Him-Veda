<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="HimVeda.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reset Password
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <h2 class="text-center mb-4" style="margin-bottom: 2rem;">Reset Password</h2>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="text-center mb-4" style="display:block; margin-bottom: 1rem;" BackColor="#fee2e2" ForeColor="#ef4444" Visible="false"></asp:Label>

        <p style="text-align: center; margin-bottom: 1.5rem; color: var(--text-muted);">
            Please enter your new password below.
        </p>

        <div class="form-group">
            <label class="form-label">New Password</label>
            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Minimum 6 characters"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="revNewPassword" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="Password must be at least 6 characters." CssClass="validator-error" Display="Dynamic" ValidationExpression="^.{6,}$"></asp:RegularExpressionValidator>
        </div>

        <div class="form-group">
            <label class="form-label">Confirm New Password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm your new password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:CompareValidator ID="cvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword" ErrorMessage="Passwords do not match." CssClass="validator-error" Display="Dynamic"></asp:CompareValidator>
        </div>

        <asp:Button ID="btnReset" runat="server" Text="Reset Password" CssClass="btn btn-primary" style="width: 100%; padding: 0.8rem;" OnClick="btnReset_Click" />
    </div>
</asp:Content>
