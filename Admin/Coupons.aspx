<%@ Page Title="Promotional Coupons" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Coupons.aspx.cs" Inherits="HimVeda.Admin.CouponsPage" %>

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
        
        .badge-active { background: #dcfce7; color: #166534; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
        .badge-inactive { background: #fee2e2; color: #991b1b; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Statistics -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e0e7ff; color:#4f46e5;"><i class="fa-solid fa-ticket"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Promo Codes</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalCoupons" runat="server">0</asp:Literal></h2>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#dcfce7; color:#166534;"><i class="fa-solid fa-check-circle"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Active Promos</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litActiveCoupons" runat="server">0</asp:Literal></h2>
            </div>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem;" Visible="false"></asp:Label>

    <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem;">
        
        <!-- Add / Edit Form -->
        <div class="card" style="padding: 1.5rem; align-self: start;">
            <h3><asp:Literal ID="litFormTitle" runat="server" Text="Add New Coupon"></asp:Literal></h3>
            <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
            <asp:HiddenField ID="hiddenCouponID" runat="server" Value="" />
            
            <div class="form-group">
                <label class="form-label">Coupon Code</label>
                <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="e.g. SUMMER50" required="required"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Discount Type</label>
                <asp:DropDownList ID="ddlDiscountType" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Percentage" Value="Percentage"></asp:ListItem>
                    <asp:ListItem Text="Fixed Amount" Value="Flat"></asp:ListItem>
                </asp:DropDownList>
            </div>
            
            <div class="form-group">
                <label class="form-label">Discount Value</label>
                <asp:TextBox ID="txtDiscountValue" runat="server" CssClass="form-control" type="number" step="0.01" required="required"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Minimum Order Amount</label>
                <asp:TextBox ID="txtMinOrder" runat="server" CssClass="form-control" type="number" step="0.01" placeholder="0 if no minimum"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Start Date</label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date" required="required"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">End Date</label>
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date" required="required"></asp:TextBox>
            </div>

            <div class="form-group flex justify-start items-center gap-1 mt-2">
                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                <label class="form-label" style="margin-bottom: 0;">Is Active</label>
            </div>

            <div class="flex gap-2 mt-4">
                <asp:Button ID="btnSave" runat="server" Text="Save Coupon" CssClass="btn btn-primary" OnClick="btnSave_Click" style="width: 100%;" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" formnovalidate />
            </div>
        </div>

        <!-- Grid List -->
        <asp:GridView ID="gvCoupons" runat="server" AutoGenerateColumns="False" CssClass="data-table" GridLines="None" DataKeyNames="CouponID" OnRowCommand="gvCoupons_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="S.N.">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Code" HeaderText="Code" ItemStyle-Font-Bold="true" />
                <asp:BoundField DataField="DiscountType" HeaderText="Type" />
                <asp:BoundField DataField="DiscountValue" HeaderText="Value" />
                <asp:BoundField DataField="MinOrderAmount" HeaderText="Min Order" DataFormatString="{0:C}" />
                <asp:BoundField DataField="EndDate" HeaderText="Expires" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Disabled" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCoupon" CommandArgument='<%# Eval("CouponID") %>' CssClass="action-btn" ToolTip="Edit Coupon" formnovalidate>
                            <i class="fa-solid fa-pen-to-square"></i>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCoupon" CommandArgument='<%# Eval("CouponID") %>' CssClass="action-btn delete" ToolTip="Delete Coupon" OnClientClick="return confirm('Are you sure you want to delete this coupon?');" formnovalidate>
                            <i class="fa-solid fa-trash"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
