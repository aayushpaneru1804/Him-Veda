<%@ Page Title="Product Directory" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="HimVeda.Admin.ProductsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .custom-grid { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .custom-grid th { background: #f8fafc; padding: 1.2rem; text-align: left; font-weight: 600; color: #475569; border-bottom: 2px solid #e2e8f0; }
        .custom-grid td { padding: 1rem 1.2rem; border-bottom: 1px solid #f1f5f9; color: #1e293b; vertical-align: middle; }
        .prod-img { width: 40px; height: 40px; border-radius: 8px; object-fit: cover; }
        .add-product-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem 1.75rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.06);
            border: 1px solid #e2e8f0;
        }
        .add-product-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem 1.5rem;
        }
        @media (max-width: 900px) {
            .add-product-grid { grid-template-columns: 1fr; }
        }
        .form-label-admin { display: block; font-weight: 600; font-size: 0.85rem; color: #475569; margin-bottom: 0.35rem; }
        .form-control-admin {
            width: 100%;
            padding: 0.6rem 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            box-sizing: border-box;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="margin: 0; color: #1e293b;">Product Inventory</h2>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" Visible="false" style="display:block; margin-bottom:1rem; padding:1rem; border-radius:8px;"></asp:Label>

    <div class="add-product-card">
        <h3 style="margin: 0 0 1rem 0; color: #1e293b; font-size: 1.15rem;">Add / Edit product</h3>
        <asp:HiddenField ID="hiddenProductID" runat="server" Value="" />
        <asp:HiddenField ID="hiddenExistingMainImage" runat="server" Value="" />
        <p style="color: #64748b; margin: 0 0 1.25rem 0; font-size: 0.95rem;">Assign the product to a vendor and category. Main image is stored under <code>~/Images/Products/</code>.</p>
        <div class="add-product-grid">
            <div>
                <label class="form-label-admin">Product name</label>
                <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control-admin" placeholder="e.g. Organic Shilajit"></asp:TextBox>
            </div>
            <div>
                <label class="form-label-admin">Vendor</label>
                <asp:DropDownList ID="ddlVendor" runat="server" CssClass="form-control-admin"></asp:DropDownList>
            </div>
            <div>
                <label class="form-label-admin">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control-admin"></asp:DropDownList>
            </div>
            <div>
                <label class="form-label-admin">Main image</label>
                <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control-admin" accept="image/jpeg,image/png,image/webp" />
                <asp:Image ID="imgProductPreview" runat="server" Visible="false" style="margin-top: 0.6rem; width: 80px; height: 80px; object-fit: cover; border-radius: 8px;" />
            </div>
            <div>
                <label class="form-label-admin">Price (Rs)</label>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control-admin" TextMode="Number" step="0.01"></asp:TextBox>
            </div>
            <div>
                <label class="form-label-admin">Stock quantity</label>
                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control-admin" TextMode="Number"></asp:TextBox>
            </div>
            <div style="grid-column: 1 / -1;">
                <label class="form-label-admin">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control-admin" TextMode="MultiLine" Rows="4" placeholder="Product details..."></asp:TextBox>
            </div>
            <div style="display: flex; align-items: center; gap: 1.25rem; flex-wrap: wrap;">
                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                    <asp:CheckBox ID="chkFeatured" runat="server" />
                    <span>Featured</span>
                </label>
                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                    <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                    <span>Active</span>
                </label>
            </div>
        </div>
        <div style="margin-top: 1.25rem;">
            <asp:Button ID="btnAddProduct" runat="server" Text="Add product" OnClick="btnAddProduct_Click"
                style="background: #2563eb; color: white; border: none; padding: 0.65rem 1.25rem; border-radius: 8px; font-weight: 600; cursor: pointer;" />
            <asp:Button ID="btnClearProductForm" runat="server" Text="Clear" OnClick="btnClearProductForm_Click" CausesValidation="false"
                style="margin-left: 0.5rem; background: #f1f5f9; color: #334155; border: 1px solid #e2e8f0; padding: 0.65rem 1.25rem; border-radius: 8px; cursor: pointer;" />
        </div>
    </div>

    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None" DataKeyNames="ProductID" OnRowCommand="gvProducts_RowCommand">
        <Columns>
            <asp:TemplateField HeaderText="S.N.">
                <ItemTemplate>
                    <%# Container.DataItemIndex + 1 %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Product">
                <ItemTemplate>
                    <div style="display:flex; align-items:center; gap: 10px;">
                        <img src='<%# ResolveUrl(string.IsNullOrEmpty(Convert.ToString(Eval("MainImage"))) ? "~/Images/placeholder.svg" : Eval("MainImage").ToString()) %>' class="prod-img" alt="" />
                        <span style="font-weight: 500;"><%# Eval("ProductName") %></span>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
            <asp:BoundField DataField="VendorName" HeaderText="Vendor" />
            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
            <asp:BoundField DataField="StockQty" HeaderText="Stock" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ProductID") %>'
                        CssClass="btn" style="background:#dbeafe; color:#1d4ed8; padding: 0.4rem 0.8rem; font-size: 0.85rem; border:none; margin-right: 0.4rem;">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductID") %>' 
                        CssClass="btn" style="background:#fee2e2; color:#ef4444; padding: 0.4rem 0.8rem; font-size: 0.85rem; border:none;" 
                        OnClientClick="return confirm('Are you sure you want to permanently delete this product?');">
                        <i class="fa-solid fa-trash"></i>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
