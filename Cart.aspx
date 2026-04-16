<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="HimVeda.CartPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Shopping Cart
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .cart-wrapper {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }
        @media (min-width: 992px) {
            .cart-wrapper { flex-direction: row; }
            .cart-items { flex: 2; }
            .cart-sidebar { flex: 1; }
        }
        
        .cart-item-card {
            display: flex;
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            border: 1px solid #f1f5f9;
            align-items: center;
            transition: box-shadow 0.3s;
        }
        .cart-item-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        }
        
        .cart-img-wrap {
            flex-shrink: 0;
            width: 100px;
            height: 100px;
            border-radius: 12px;
            overflow: hidden;
            margin-right: 1.5rem;
            background: #f8fafc;
        }
        .cart-img { width: 100%; height: 100%; object-fit: cover; }
        
        .cart-info { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 0.5rem; }
        .cart-title { font-size: 1.15rem; font-weight: 600; color: #1e293b; margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .cart-price { font-size: 1.1rem; color: #52B788; font-weight: 500; }
        
        .cart-actions { display: flex; align-items: center; gap: 1rem; margin-top: auto; }
        .qty-control { display: flex; align-items: center; background: #f8fafc; border-radius: 8px; padding: 0.1rem; }
        .qty-box { width: 45px; text-align: center; border: none; background: transparent; font-weight: 600; padding: 0.4rem; -moz-appearance: textfield; }
        .qty-box::-webkit-outer-spin-button, .qty-box::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        
        .cart-update-btn { padding: 0.4rem 0.8rem; background: #e2e8f0; border-radius: 6px; font-size: 0.8rem; border: none; cursor: pointer; transition: 0.2s; }
        .cart-update-btn:hover { background: #cbd5e1; }
        
        .cart-remove { margin-left: auto; color: #ef4444; background: #fee2e2; border: none; padding: 0.6rem; border-radius: 50%; cursor: pointer; display: flex; transition: auto; }
        .cart-remove:hover { background: #fca5a5;  color: #b91c1c;}
        
        .cart-subtotal { font-weight: 700; font-size: 1.2rem; color: #1e293b; text-align: right; min-width: 100px; }
        
        @media (max-width: 600px) {
            .cart-item-card { flex-direction: column; align-items: flex-start; position: relative; }
            .cart-img-wrap { margin-bottom: 1rem; width: 100%; height: 150px; }
            .cart-subtotal { mt-2; align-self: flex-start; text-align: left; }
            .cart-remove { position: absolute; top: 1rem; right: 1rem; }
        }

        .cart-summary { background: white; padding: 2rem; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid #f1f5f9; position: sticky; top: 90px;}
        .summary-title { font-size: 1.4rem; margin-bottom: 1.5rem; font-weight: 700; color: #1e293b; padding-bottom: 1rem; border-bottom: 1px solid #f1f5f9; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 1rem; font-size: 1.05rem; color: #475569; }
        .summary-total { font-size: 1.4rem; font-weight: 700; color: #1B4332; border-top: 2px dashed #cbd5e1; padding-top: 1.5rem; margin-top: 1.5rem; }
        
        .coupon-box { display: flex; margin-bottom: 1.5rem; }
        .coupon-input { flex: 1; border: 1px solid #cbd5e1; border-right: none; border-radius: 8px 0 0 8px; padding: 0.8rem; font-size: 1rem; }
        .coupon-btn { background: #1e293b; color: white; border: none; padding: 0.8rem 1.2rem; border-radius: 0 8px 8px 0; font-weight: 600; cursor: pointer; transition: 0.3s; }
        .coupon-btn:hover { background: #0f172a; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 2rem; margin-bottom: 4rem;">
        <h2 style="margin-bottom: 2rem; font-size: 2rem;"><i class="fa-solid fa-cart-shopping mr-2"></i> Your Shopping Cart</h2>

        <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem; padding: 1rem; font-size: 1rem;" Visible="false"></asp:Label>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="card" style="padding: 5rem 2rem; text-align: center; border-radius: 16px; background: white;">
            <i class="fa-solid fa-cart-plus" style="font-size: 5rem; color: #cbd5e1; margin-bottom: 1.5rem;"></i>
            <h3 style="font-size: 1.8rem; margin-bottom: 0.5rem;">Your cart is empty</h3>
            <p style="color: var(--text-muted); margin-bottom: 2.5rem; font-size: 1.1rem;">Looks like you haven't added any of our authentic products yet.</p>
            <a href="Products.aspx" class="btn btn-primary" style="padding: 1rem 2rem; font-size: 1.1rem; border-radius: 50px;">Explore Collection</a>
        </asp:Panel>

        <asp:Panel ID="pnlCart" runat="server">
            <div class="cart-wrapper">
                
                <!-- Items List -->
                <div class="cart-items">
                    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                        <ItemTemplate>
                            <div class="cart-item-card">
                                <div class="cart-img-wrap">
                                    <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' class="cart-img" />
                                </div>
                                
                                <div class="cart-info">
                                    <h3 class="cart-title"><%# Eval("ProductName") %></h3>
                                    <div class="cart-price"><%# Eval("UnitPrice", "{0:C}") %></div>
                                    
                                    <div class="cart-actions">
                                        <div class="qty-control" style="display:flex; flex-direction:column;">
                                            <asp:TextBox ID="txtGridQty" runat="server" Text='<%# Eval("Quantity") %>' CssClass="qty-box" TextMode="Number" min="1"></asp:TextBox>
                                            <asp:RangeValidator ID="rvGridQty" runat="server" ControlToValidate="txtGridQty" ErrorMessage="Positive quantities only." MinimumValue="1" MaximumValue="999" Type="Integer" ForeColor="Red" style="font-size:0.75rem;" Display="Dynamic"></asp:RangeValidator>
                                        </div>
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="UpdateQty" CommandArgument='<%# Eval("CartItemID") %>' CssClass="cart-update-btn">Update</asp:LinkButton>
                                    </div>
                                </div>
                                
                                <div class="cart-subtotal">
                                    <%# Eval("SubTotal", "{0:C}") %>
                                </div>
                                
                                <asp:LinkButton ID="btnRemove" runat="server" CommandName="RemoveItem" CommandArgument='<%# Eval("CartItemID") %>' CssClass="cart-remove" ToolTip="Remove Item">
                                    <i class="fa-solid fa-xmark"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Summary Panel -->
                <div class="cart-sidebar">
                    <div class="cart-summary">
                        <h3 class="summary-title">Order Summary</h3>
                        
                        <div class="coupon-box">
                            <asp:TextBox ID="txtCoupon" runat="server" CssClass="coupon-input" placeholder="Enter promo code"></asp:TextBox>
                            <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply" CssClass="coupon-btn" OnClick="btnApplyCoupon_Click" />
                        </div>
                        <asp:Label ID="lblCouponMsg" runat="server" style="display:block; margin-bottom: 1.5rem; font-size: 0.95rem; font-weight: 500;" Visible="false"></asp:Label>

                        <div class="summary-row">
                            <span>Subtotal</span>
                            <span style="font-weight: 500; color: #1e293b;"><asp:Literal ID="litSubTotal" runat="server"></asp:Literal></span>
                        </div>
                        <div class="summary-row">
                            <span>Discount <asp:Label ID="lblDiscountName" runat="server" CssClass="badge badge-success" style="font-size:0.75rem; margin-left: 0.5rem;"></asp:Label></span>
                            <span style="color: var(--success); font-weight: 600;">-<asp:Literal ID="litDiscount" runat="server">Rs 0.00</asp:Literal></span>
                        </div>
                        <div class="summary-row">
                            <span>Estimated Shipping</span>
                            <span style="color: var(--success); font-weight: 600;">Free</span>
                        </div>
                        
                        <div class="summary-row summary-total">
                            <span>Total</span>
                            <span><asp:Literal ID="litTotal" runat="server"></asp:Literal></span>
                        </div>

                        <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Secure Checkout" CssClass="btn btn-primary" style="width: 100%; padding: 1.2rem; font-size: 1.1rem; margin-top: 1.5rem; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(82, 183, 136, 0.3);" OnClick="btnCheckout_Click" />
                        <div style="text-align: center; margin-top: 1rem; color: #64748b; font-size: 0.85rem;">
                            <i class="fa-solid fa-lock mr-2"></i>Secure Encrypted Payment
                        </div>
                    </div>
                </div>

            </div>
        </asp:Panel>

    </div>
</asp:Content>
