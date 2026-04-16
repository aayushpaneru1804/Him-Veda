<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="HimVeda.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    My Profile
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .profile-wrapper { display: flex; flex-direction: column; background: #ffffff; border-radius: 20px; box-shadow: 0 20px 40px -15px rgba(0,0,0,0.1); overflow: hidden; margin-top: 2rem; border: 1px solid rgba(0,0,0,0.05); }
        @media (min-width: 768px) { .profile-wrapper { flex-direction: row; } }
        
        .profile-sidebar { background: linear-gradient(135deg, #1b4332, #2d6a4f); padding: 3rem 2rem; color: white; text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center; min-width: 300px; position: relative; overflow: hidden; }
        .profile-sidebar::before { content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%); pointer-events: none; }
        .profile-avatar-container { width: 130px; height: 130px; border-radius: 50%; border: 3px solid rgba(255,255,255,0.5); display: flex; justify-content: center; align-items: center; overflow: hidden; margin-bottom: 1.5rem; background: rgba(0,0,0,0.1); box-shadow: 0 10px 25px rgba(0,0,0,0.3); }
        .profile-avatar-img { width: 100%; height: 100%; object-fit: cover; }
        .profile-name { font-size: 1.8rem; margin-bottom: 0.5rem; font-weight: 700; letter-spacing: -0.5px; color: #ffffff; text-shadow: 0 2px 5px rgba(0,0,0,0.3); }
        .profile-role { color: #d8f3dc; font-size: 1rem; letter-spacing: 1px; text-transform: uppercase; font-weight: 600; padding: 0.3rem 1rem; background: rgba(0,0,0,0.2); border-radius: 20px; display: inline-block; }
        
        .profile-main { padding: 3rem; flex: 1; }
        .profile-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid #f1f5f9; }
        .profile-header h2 { font-size: 1.6rem; color: #1e293b; font-weight: 700; }
        
        .form-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 900px) { .form-grid { grid-template-columns: 1fr 1fr; } }
        .form-group-full { grid-column: 1 / -1; }
        
        .input-label { font-weight: 600; color: #475569; display: block; margin-bottom: 0.5rem; font-size: 0.95rem; }
        .profile-input { background: #f8fafc; border: 1.5px solid #e2e8f0; border-radius: 10px; padding: 0.9rem 1.2rem; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); width: 100%; color: #1e293b; font-size: 1rem; }
        .profile-input:focus { border-color: #2d6a4f; background: #ffffff; outline: none; box-shadow: 0 0 0 4px rgba(45,106,79,0.1); transform: translateY(-2px); }
        .profile-input[readonly] { background-color: #f1f5f9; color: #64748b; cursor: not-allowed; border-color: #cbd5e1; }
        
        .btn-update { background: linear-gradient(135deg, #2d6a4f, #1b4332); color: white; padding: 1rem 2.5rem; font-size: 1.1rem; border-radius: 10px; border: none; font-weight: 600; cursor: pointer; transition: all 0.3s; box-shadow: 0 10px 15px -3px rgba(45,106,79,0.4); margin-top: 1rem; display: inline-flex; align-items: center; justify-content: center; }
        .btn-update:hover { transform: translateY(-3px); box-shadow: 0 15px 25px -5px rgba(45,106,79,0.5); background: linear-gradient(135deg, #1b4332, #0f2d20); }
        
        .alert-custom { display: flex; align-items: center; padding: 1rem 1.5rem; border-radius: 10px; font-weight: 600; margin-bottom: 2rem; animation: slideDown 0.3s ease-out; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-4">
        
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert-custom"></asp:Label>
        
        <div class="profile-wrapper">
            <!-- Sidebar -->
            <div class="profile-sidebar">
                <div class="profile-avatar-container">
                    <asp:Image ID="imgAvatar" runat="server" CssClass="profile-avatar-img" ImageUrl="~/Images/default-avatar.png" />
                </div>
                <!-- We dynamically set name here using inline expression from session OR just a welcome message -->
                <h3 class="profile-name"><%= Session["FullName"] %></h3>
                <span class="profile-role">Customer</span>
                
                <div style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid rgba(255,255,255,0.2); width: 100%;">
                    <p style="font-size: 0.9rem; opacity: 0.8;"><i class="fa-solid fa-shield-check mr-2"></i> Your data is securely stored.</p>
                </div>
            </div>
            
            <!-- Main Content Form -->
            <div class="profile-main">
                <div class="profile-header">
                    <h2><i class="fa-solid fa-address-card mr-2" style="color: var(--primary-color);"></i> Personal Information</h2>
                </div>
                
                <div class="form-grid">
                    <div class="form-group-full">
                        <label class="input-label">Profile Image (Optional)</label>
                        <asp:FileUpload ID="fileProfileImage" runat="server" CssClass="profile-input" accept="image/*" />
                        <small style="color: #94a3b8; display: block; margin-top: 0.4rem;">Select an image to update your avatar.</small>
                    </div>

                    <div class="form-group-full">
                        <label class="input-label">Full Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="profile-input" placeholder="Enter your full name"></asp:TextBox>
                    </div>
                    
                    <div>
                        <label class="input-label">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="profile-input" ReadOnly="true"></asp:TextBox>
                        <small style="color: #94a3b8; display: block; margin-top: 0.4rem; font-size: 0.85rem;"><i class="fa-solid fa-lock mr-1"></i> Cannot be changed</small>
                    </div>
                    
                    <div>
                        <label class="input-label">Phone Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="profile-input" placeholder="Enter your phone number"></asp:TextBox>
                    </div>
                    
                    <div class="form-group-full">
                        <label class="input-label">Delivery Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="profile-input" TextMode="MultiLine" Rows="4" placeholder="Enter your full delivery address"></asp:TextBox>
                    </div>
                </div>
                
                <div style="text-align: right; margin-top: 1.5rem;">
                    <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn-update" OnClick="btnUpdate_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
