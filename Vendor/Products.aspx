<%@ Page Title="My Products" Language="C#" MasterPageFile="~/Vendor/Vendor.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="HimVeda.Vendor.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    My Products
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .grid-view {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
        }
        .grid-view th, .grid-view td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        .grid-view th {
            background-color: var(--secondary-color);
            color: var(--primary-dark);
            font-weight: 600;
        }
        .grid-view tr:hover { background-color: #f8fafc; }
        .product-img-tiny {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex justify-between items-center mb-4" style="margin-bottom: 2rem;">
        <h2><i class="fa-solid fa-boxes-stacked mr-2"></i> Manage My Products</h2>
        <asp:Button ID="btnToggleAdd" runat="server" Text="+ Add New Product" CssClass="btn btn-primary" OnClick="btnToggleAdd_Click" />
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem;" Visible="false"></asp:Label>

    <!-- Add/Edit Form Panel -->
    <asp:Panel ID="pnlForm" runat="server" Visible="false" CssClass="card" style="padding: 1.5rem; margin-bottom: 2rem;">
        <h3>Product Details</h3>
        <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
        <asp:HiddenField ID="hiddenProductID" runat="server" />

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
            <!-- Left Column -->
            <div>
                <div class="form-group">
                    <label class="form-label">Product Name</label>
                    <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" placeholder="e.g. Organic Shilajit"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="form-group">
                    <label class="form-label">Price (Rs)</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="form-label">Stock Quantity</label>
                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                </div>
            </div>
            
            <!-- Right Column -->
            <div>
                <div class="form-group">
                    <label class="form-label">Main Image</label>
                    <asp:FileUpload ID="fuMainImage" runat="server" CssClass="form-control" />
                    <asp:Image ID="imgPreview" runat="server" Visible="false" style="width: 100px; height: 100px; object-fit: cover; margin-top: 10px; border-radius: 8px;" />
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Detailed product info..."></asp:TextBox>
                </div>
                <div class="form-group flex items-center gap-2">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                    <label class="form-label" style="margin-bottom: 0;">Is Active</label>
                    &nbsp;&nbsp;&nbsp;
                    <asp:CheckBox ID="chkIsFeatured" runat="server" />
                    <label class="form-label" style="margin-bottom: 0;">Feature Product</label>
                </div>
            </div>
        </div>
        
        <div class="flex gap-2" style="margin-top: 1.5rem;">
            <asp:Button ID="btnSave" runat="server" Text="Save Product" CssClass="btn btn-primary" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline" OnClick="btnCancel_Click" CausesValidation="false" />
        </div>

        <!-- Variations Section -->
        <asp:Panel ID="pnlVariations" runat="server" Visible="false" style="margin-top: 3rem; border-top: 1px solid #e2e8f0; padding-top: 1.5rem;">
            <h3>Product Variations (Size/Color)</h3>
            <p style="color: var(--text-muted); margin-bottom: 1rem;">Manage different variations like sizes or colors for this product. <em>(Save product first if new)</em></p>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr 1fr 1fr auto; gap: 1rem; align-items: end; margin-bottom: 1.5rem;">
                <div>
                    <label class="form-label" style="font-size: 0.9rem;">Size</label>
                    <asp:TextBox ID="txtVarSize" runat="server" CssClass="form-control" placeholder="e.g. 500g"></asp:TextBox>
                </div>
                <div>
                    <label class="form-label" style="font-size: 0.9rem;">Color</label>
                    <asp:TextBox ID="txtVarColor" runat="server" CssClass="form-control" placeholder="e.g. Red"></asp:TextBox>
                </div>
                <div>
                    <label class="form-label" style="font-size: 0.9rem;">Extra Price (+)</label>
                    <asp:TextBox ID="txtVarPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" Text="0"></asp:TextBox>
                </div>
                <div>
                    <label class="form-label" style="font-size: 0.9rem;">Stock</label>
                    <asp:TextBox ID="txtVarStock" runat="server" CssClass="form-control" TextMode="Number" Text="0"></asp:TextBox>
                </div>
                <div>
                    <label class="form-label" style="font-size: 0.9rem;">SKU</label>
                    <asp:TextBox ID="txtVarSKU" runat="server" CssClass="form-control" placeholder="Optional"></asp:TextBox>
                </div>
                <div>
                    <asp:Button ID="btnAddVariation" runat="server" Text="Add" CssClass="btn btn-outline" style="padding: 0.8rem 1.5rem;" OnClick="btnAddVariation_Click" CausesValidation="false" />
                </div>
            </div>

            <asp:GridView ID="gvVariations" runat="server" AutoGenerateColumns="false" CssClass="grid-view" GridLines="None"
                DataKeyNames="VariationID" OnRowCommand="gvVariations_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Size" HeaderText="Size" />
                    <asp:BoundField DataField="Color" HeaderText="Color" />
                    <asp:BoundField DataField="AdditionalPrice" HeaderText="Extra Price" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="Stock" HeaderText="Stock" />
                    <asp:BoundField DataField="SKU" HeaderText="SKU" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelVar" runat="server" CommandName="DeleteVariation" CommandArgument='<%# Eval("VariationID") %>' CssClass="text-danger" CausesValidation="false">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>

    <!-- Product Grid -->
    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="false" CssClass="grid-view" GridLines="None"
        DataKeyNames="ProductID" OnRowCommand="gvProducts_RowCommand">
        <Columns>
            <asp:TemplateField HeaderText="Image">
                <ItemTemplate>
                    <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' class="product-img-tiny" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
            <asp:BoundField DataField="StockQty" HeaderText="Stock" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='badge <%# Convert.ToBoolean(Eval("IsActive")) ? "badge-success" : "badge-warning" %>'>
                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Archived" %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-outline" style="padding: 0.3rem 0.6rem; font-size: 0.8rem;">Edit</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>
