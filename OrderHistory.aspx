<%@ Page Title="My Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderHistory.aspx.cs" Inherits="HimVeda.OrderHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    My Orders
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .order-card { background: white; border-radius: var(--border-radius); box-shadow: var(--shadow-sm); margin-bottom: 2rem; overflow: hidden; }
        .order-header { display: flex; justify-content: space-between; align-items: center; background: #f8fafc; padding: 1.5rem; border-bottom: 1px solid #e2e8f0; }
        .order-info { display: flex; gap: 2rem; font-size: 0.9rem; }
        .order-details { padding: 1.5rem; }
        .item-row { display: flex; align-items: center; gap: 1.5rem; border-bottom: 1px dashed #e2e8f0; padding: 1rem 0; }
        .item-row:last-child { border-bottom: none; }
        .status-badge { padding: 0.4rem 1rem; border-radius: 999px; font-weight: 600; font-size: 0.85rem; }
        .status-Pending { background: #fef3c7; color: #b45309; }
        .status-Processing { background: #e0e7ff; color: #4338ca; }
        .status-SentOut { background: #dbeafe; color: #1d4ed8; }
        .status-Delivered { background: #d1fae5; color: #047857; }
        .status-Cancelled { background: #fee2e2; color: #b91c1c; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 2rem; max-width: 900px;">
        <h2 style="margin-bottom: 2rem;"><i class="fa-solid fa-box-open mr-2"></i> Order History & Tracking</h2>

        <asp:Label ID="lblMessage" runat="server" CssClass="text-center mb-4" style="display:block; color: var(--text-muted);" Visible="false"></asp:Label>

        <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
            <ItemTemplate>
                <div class="order-card">
                    <div class="order-header">
                        <div class="order-info">
                            <div>
                                <span style="display:block; color: var(--text-muted); margin-bottom:0.2rem;">Order placed</span>
                                <strong style="color: var(--text-main);"><%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %></strong>
                            </div>
                            <div>
                                <span style="display:block; color: var(--text-muted); margin-bottom:0.2rem;">Total</span>
                                <strong style="color: var(--text-main);"><%# Eval("TotalAmount", "{0:C}") %></strong>
                            </div>
                            <div>
                                <span style="display:block; color: var(--text-muted); margin-bottom:0.2rem;">Order #</span>
                                <strong style="color: var(--text-main);"><%# Eval("OrderID") %></strong>
                            </div>
                        </div>
                        <div>
                            <span class='status-badge status-<%# Eval("OrderStatus").ToString().Replace(" ", "") %>'>
                                <%# Eval("OrderStatus") %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="order-details">
                        <!-- Nested Repeater for Order Items -->
                        <asp:Repeater ID="rptItems" runat="server">
                            <ItemTemplate>
                                <div class="item-row">
                                    <div style="flex: 1;">
                                        <h4 style="margin-bottom: 0.3rem;"><%# Eval("ProductName") %></h4>
                                        <p style="color: var(--text-muted); font-size: 0.9rem;">Qty: <%# Eval("Quantity") %> | <%# Eval("UnitPrice", "{0:C}") %></p>
                                    </div>
                                    <div>
                                        <strong><%# Eval("SubTotal", "{0:C}") %></strong>
                                    </div>
                                    <div style="width: 150px; text-align: right;">
                                        <!-- Review button shown only if delivered -->
                                        <%# Eval("OrderStatus").ToString() == "Delivered" ? 
                                            "<a href='Feedback.aspx?pid=" + Eval("ProductID") + "&oid=" + Eval("OrderID") + "' class='btn btn-outline' style='font-size:0.8rem; padding:0.4rem 0.8rem;'>Write Review</a>" 
                                            : "<span style='color:var(--text-muted); font-size:0.8rem;'>In progress...</span>" %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div style="margin-top: 1.5rem; font-size: 0.9rem; background: #f8fafc; padding: 1rem; border-radius: var(--border-radius);">
                            <strong>Delivery Address:</strong> <%# Eval("ShippingAddress") %> <br />
                            <strong>Payment Method:</strong> <%# Eval("PaymentMethod") %> (<%# Eval("PaymentStatus") %>)
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
