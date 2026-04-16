<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="HimVeda.Admin.UsersPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .data-table { width: 100%; border-collapse: collapse; margin-top: 1rem; background: white; border-radius: var(--border-radius); overflow: hidden; box-shadow: var(--shadow-sm); }
        .data-table th, .data-table td { padding: 1rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .data-table th { background-color: #f8fafc; color: #475569; font-weight: 600; }
        .data-table tr:hover { background-color: #f8fafc; }
        .action-btn { background: none; border: none; cursor: pointer; color: var(--text-muted); font-size: 1.1rem; margin-right: 0.5rem; }
        .action-btn:hover { color: var(--primary-color); }
        .action-btn.delete:hover { color: var(--danger); }
        
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 15px; margin-bottom: 2rem; border: 1px solid #f1f5f9; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Statistics -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e0e7ff; color:#4f46e5;"><i class="fa-solid fa-users"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Registered Users</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></h2>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#dcfce7; color:#166534;"><i class="fa-solid fa-user-check"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Active Users</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litActiveUsers" runat="server">0</asp:Literal></h2>
            </div>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem;" Visible="false"></asp:Label>

    <div style="display: grid; grid-template-columns: 1.2fr 2fr; gap: 2rem;">
        
        <!-- Add / Edit Form -->
        <div class="card" style="padding: 1.5rem; align-self: start;">
            <h3><asp:Literal ID="litFormTitle" runat="server" Text="Add New User"></asp:Literal></h3>
            <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
            <asp:HiddenField ID="hiddenUserID" runat="server" Value="" />
            
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="John Doe" required="required"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="john@example.com" required="required"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Leave blank to keep existing (if editing)"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Phone</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">City</label>
                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group flex justify-center items-center gap-1" style="flex-direction: row; margin-top: 2rem;">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                    <label class="form-label" style="margin-bottom: 0;">Is Active</label>
                </div>
            </div>

            <div class="flex gap-2 mt-2">
                <asp:Button ID="btnSave" runat="server" Text="Save User" CssClass="btn btn-primary" OnClick="btnSave_Click" style="width: 100%;" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" formnovalidate />
            </div>
        </div>

        <!-- Grid List -->
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="data-table" GridLines="None" DataKeyNames="UserID" OnRowCommand="gvUsers_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="S.N.">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                <asp:BoundField DataField="Email" HeaderText="Email Address" />
                <asp:BoundField DataField="CreatedAt" HeaderText="Registered" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='badge <%# Eval("Status").ToString() == "Active" ? "badge-success" : "badge-warning" %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditUser" CommandArgument='<%# Eval("UserID") %>' CssClass="action-btn" ToolTip="Edit User" formnovalidate>
                            <i class="fa-solid fa-pen-to-square"></i>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>' CssClass="action-btn delete" ToolTip="Delete User" OnClientClick="return confirm('Are you sure you want to completely delete this user?');" formnovalidate>
                            <i class="fa-solid fa-trash"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
