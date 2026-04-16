<%@ Page Title="Manage Vendors" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Vendors.aspx.cs" Inherits="HimVeda.Admin.VendorsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .data-table { width: 100%; border-collapse: collapse; margin-top: 1rem; background: white; border-radius: var(--border-radius); overflow: hidden; box-shadow: var(--shadow-sm); }
        .data-table th, .data-table td { padding: 1rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .data-table th { background-color: #f8fafc; color: #475569; font-weight: 600; }
        .data-table tr:hover { background-color: #f8fafc; }
        .action-btn { background: none; border: none; cursor: pointer; color: var(--text-muted); font-size: 1.1rem; margin-right: 0.5rem; }
        .action-btn:hover { color: var(--primary-color); }
        
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 15px; margin-bottom: 2rem; border: 1px solid #f1f5f9; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        
        .badge-pending { background: #fef08a; color: #854d0e; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
        .badge-approved { background: #dcfce7; color: #166534; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
        .badge-rejected { background: #fee2e2; color: #991b1b; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Statistics -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e0e7ff; color:#4f46e5;"><i class="fa-solid fa-store"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Vendors</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalVendors" runat="server">0</asp:Literal></h2>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#fef08a; color:#854d0e;"><i class="fa-solid fa-hourglass-half"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Pending Approvals</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litPendingVendors" runat="server">0</asp:Literal></h2>
            </div>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem;" Visible="false"></asp:Label>

    <div style="display: grid; grid-template-columns: 1.2fr 2fr; gap: 2rem;">
        
        <!-- Add / Edit Form -->
        <div class="card" style="padding: 1.5rem; align-self: start;">
            <h3><asp:Literal ID="litFormTitle" runat="server" Text="Add New Vendor"></asp:Literal></h3>
            <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
            <asp:HiddenField ID="hiddenVendorID" runat="server" Value="" />
            
            <div class="form-group">
                <label class="form-label">Business Name</label>
                <asp:TextBox ID="txtBusinessName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Contact Person (Vendor Name)</label>
                <asp:TextBox ID="txtVendorName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required="required"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Leave blank to keep existing"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Phone & Address</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone" style="margin-bottom: 0.5rem;"></asp:TextBox>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Business Address"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Account Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                    <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="flex gap-2 mt-2">
                <asp:Button ID="btnSave" runat="server" Text="Save Vendor" CssClass="btn btn-primary" OnClick="btnSave_Click" style="width: 100%;" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" formnovalidate />
            </div>
        </div>

        <!-- Grid List -->
        <asp:GridView ID="gvVendors" runat="server" AutoGenerateColumns="False" CssClass="data-table" GridLines="None" DataKeyNames="VendorID" OnRowCommand="gvVendors_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="S.N.">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="BusinessName" HeaderText="Business" />
                <asp:BoundField DataField="VendorName" HeaderText="Contact" />
                <asp:BoundField DataField="Email" HeaderText="Email Address" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# Eval("Status").ToString() == "Approved" ? "badge-approved" : (Eval("Status").ToString() == "Pending" ? "badge-pending" : "badge-rejected") %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditVendor" CommandArgument='<%# Eval("VendorID") %>' CssClass="action-btn" ToolTip="Edit Vendor" formnovalidate>
                            <i class="fa-solid fa-pen-to-square"></i>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="ApproveVendor" CommandArgument='<%# Eval("VendorID") %>' CssClass="action-btn" ToolTip="Quick Approve" style="color:#166534;" formnovalidate>
                            <i class="fa-solid fa-check"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
