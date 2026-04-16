<%@ Page Title="Order Logistics" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="HimVeda.Admin.OrdersPage" %>

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
        .badge-shipped { background: #bae6fd; color: #0369a1; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
        .badge-delivered { background: #dcfce7; color: #166534; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Statistics -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e0e7ff; color:#4f46e5;"><i class="fa-solid fa-boxes-packing"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Orders</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></h2>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#dcfce7; color:#166534;"><i class="fa-solid fa-money-bill-wave"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Revenue</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalRevenue" runat="server">Rs. 0</asp:Literal></h2>
            </div>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem;" Visible="false"></asp:Label>

    <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem;">
        
        <!-- Add / Edit Form -->
        <div class="card" style="padding: 1.5rem; align-self: start;">
            <h3><asp:Literal ID="litFormTitle" runat="server" Text="Update Order Status"></asp:Literal></h3>
            <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
            <asp:HiddenField ID="hiddenOrderID" runat="server" Value="" />
            
            <div class="form-group">
                <label class="form-label">Order ID</label>
                <asp:TextBox ID="txtOrderID" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Customer Name</label>
                <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Order Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                    <asp:ListItem Text="Shipped" Value="Shipped"></asp:ListItem>
                    <asp:ListItem Text="Delivered" Value="Delivered"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="flex gap-2 mt-4">
                <asp:Button ID="btnSave" runat="server" Text="Update Status" CssClass="btn btn-primary" OnClick="btnSave_Click" style="width: 100%;" Enabled="false" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" formnovalidate />
            </div>
            <p style="font-size: 0.85rem; color: #64748b; margin-top: 10px;">Note: You cannot create fake orders manually from the Admin dashboard. Orders must be placed securely by customers.</p>
        </div>

        <!-- Grid List -->
        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="data-table" GridLines="None" DataKeyNames="OrderID" OnRowCommand="gvOrders_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="S.N.">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="FullName" HeaderText="Customer" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="{0:C}" />
                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment" />
                <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:TemplateField HeaderText="State">
                    <ItemTemplate>
                        <span class='<%# Eval("OrderStatus").ToString() == "Delivered" ? "badge-delivered" : (Eval("OrderStatus").ToString() == "Shipped" ? "badge-shipped" : "badge-pending") %>'>
                            <%# Eval("OrderStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditOrder" CommandArgument='<%# Eval("OrderID") %>' CssClass="action-btn" ToolTip="Edit Status" formnovalidate>
                            <i class="fa-solid fa-pen-to-square"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
