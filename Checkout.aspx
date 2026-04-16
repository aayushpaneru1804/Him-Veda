<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="HimVeda.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Checkout
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .checkout-layout { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; margin-top: 2rem; }
        .checkout-panel { background: white; padding: 2rem; border-radius: var(--border-radius); box-shadow: var(--shadow-sm); margin-bottom: 2rem; }
        .panel-title { font-size: 1.5rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 1.5rem; border-bottom: 2px solid #e2e8f0; padding-bottom: 0.5rem; }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 1rem; border-bottom: 1px dashed #e2e8f0; padding-bottom: 0.5rem; }
        .summary-total { font-size: 1.5rem; font-weight: 700; color: var(--primary-dark); display: flex; justify-content: space-between; margin-top: 1rem; padding-top: 1rem; border-top: 2px solid #cbd5e1; }
        .payment-option { display: block; border: 1px solid #cbd5e1; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem; cursor: pointer; transition: all 0.2s; }
        .payment-option:hover { border-color: var(--primary-color); background-color: var(--secondary-color); }
        .payment-option input[type="radio"] { margin-right: 1rem; }
        
        @media (max-width: 768px) {
            .checkout-layout { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container checkout-layout">
        
        <!-- Left: Forms -->
        <div>
            <asp:Label ID="lblError" runat="server" CssClass="badge badge-warning mb-4" style="display:block; margin-bottom: 1rem; font-size: 1rem;" Visible="false"></asp:Label>
            
            <asp:Panel ID="pnlCheckout" runat="server">
                <div class="checkout-panel">
                    <h3 class="panel-title">1. Shipping Address</h3>
                    <div class="form-group">
                        <label class="form-label">Full Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="House no, Street area, Landmark"></asp:TextBox>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label">City</label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="Kathmandu"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Postal Code</label>
                            <asp:TextBox ID="txtPostal" runat="server" CssClass="form-control" placeholder="44600"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="checkout-panel">
                    <h3 class="panel-title">2. Payment Method</h3>
                    
                    <label class="payment-option flex items-center">
                        <asp:RadioButton ID="rbCOD" runat="server" GroupName="PaymentMethod" Checked="true" />
                        <div>
                            <div style="font-weight: 600;">Cash on Delivery</div>
                            <div style="font-size: 0.9rem; color: var(--text-muted);">Pay when you receive your order context.</div>
                        </div>
                    </label>

                    <label class="payment-option flex items-center">
                        <asp:RadioButton ID="rbOnline" runat="server" GroupName="PaymentMethod" />
                        <div>
                            <div style="font-weight: 600;">Online Payment (Simulation)</div>
                            <div style="font-size: 0.9rem; color: var(--text-muted);">Pay via Card / Wallet.</div>
                        </div>
                    </label>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="checkout-panel" style="text-align: center; padding: 4rem 2rem;">
                <i class="fa-solid fa-circle-check" style="color: var(--success); font-size: 4rem; margin-bottom: 1rem;"></i>
                <h2>Order Placed Successfully!</h2>
                <p style="color: var(--text-muted); margin-bottom: 2rem;">Your order tracking ID is <strong>#<asp:Literal ID="litOrderID" runat="server"></asp:Literal></strong></p>
                <a href="Default.aspx" class="btn btn-outline">Return to Home</a>
            </asp:Panel>
        </div>

        <!-- Right: Order Summary -->
        <asp:Panel ID="pnlSummary" runat="server">
            <div class="checkout-panel" style="position: sticky; top: 100px;">
                <h3 class="panel-title">Order Info</h3>
                
                <div class="summary-item">
                    <span>Subtotal</span>
                    <span><asp:Literal ID="litSubTotal" runat="server"></asp:Literal></span>
                </div>
                
                <asp:Panel ID="pnlDiscount" runat="server" CssClass="summary-item" Visible="false">
                    <span>Discount (<asp:Literal ID="litCouponCode" runat="server"></asp:Literal>)</span>
                    <span style="color: var(--success);">-<asp:Literal ID="litDiscount" runat="server"></asp:Literal></span>
                </asp:Panel>
                
                <div class="summary-item">
                    <span>Shipping</span>
                    <span>Free</span>
                </div>
                
                <div class="summary-total">
                    <span>Total Amount</span>
                    <span><asp:Literal ID="litTotal" runat="server"></asp:Literal></span>
                </div>

                <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order Now" CssClass="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.1rem; margin-top: 1.5rem;" OnClick="btnPlaceOrder_Click" />
            </div>
        </asp:Panel>

    </div>
</asp:Content>
