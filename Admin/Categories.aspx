<%@ Page Title="Manage Categories" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="HimVeda.Admin.Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Categories
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }
        .data-table th, .data-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        .data-table th {
            background-color: var(--secondary-color);
            color: var(--primary-dark);
            font-weight: 600;
        }
        .data-table tr:hover { background-color: #f8fafc; }
        .action-btn { background: none; border: none; cursor: pointer; color: var(--text-muted); font-size: 1.1rem; margin-right: 0.5rem; }
        .action-btn:hover { color: var(--primary-color); }
        .action-btn.delete:hover { color: var(--danger); }
        .cat-table-thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 8px; background: #f1f5f9; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex justify-between items-center mb-4" style="margin-bottom: 2rem;">
        <h2><i class="fa-solid fa-list mr-2"></i> Manage Categories</h2>
    </div>

    <!-- Feedback Message -->
    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; margin-bottom: 1rem;" Visible="false"></asp:Label>

    <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem;">
        
        <!-- Add / Edit Category Form -->
        <div class="card" style="padding: 1.5rem; align-self: start;">
            <h3>Add New Category</h3>
            <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
            <asp:HiddenField ID="hiddenCategoryID" runat="server" Value="" />
            
            <div class="form-group">
                <label class="form-label">Category Name</label>
                <asp:TextBox ID="txtCatName" runat="server" CssClass="form-control" placeholder="e.g. Herbal Teas"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Brief details..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Category image</label>
                <asp:FileUpload ID="fuCategoryImage" runat="server" CssClass="form-control" accept="image/jpeg,image/png,image/webp" />
                <small style="color: var(--text-muted); display: block; margin-top: 0.35rem;">JPG, PNG, or WebP. Shown on the public Categories page.</small>
                <asp:HiddenField ID="hiddenExistingCategoryImage" runat="server" Value="" />
                <asp:Image ID="imgCategoryPreview" runat="server" Visible="false" CssClass="cat-table-thumb" style="margin-top: 0.75rem;" />
            </div>

            <div class="form-group flex items-center gap-1">
                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                <label class="form-label" style="margin-bottom: 0;">Is Active</label>
            </div>

            <div class="flex gap-2">
                <asp:Button ID="btnSave" runat="server" Text="Save Category" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" />
            </div>
        </div>

        <!-- Categories List -->
        <div>
            <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                <HeaderTemplate>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>S.N.</th>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <td style="font-weight: 600; color: #475569;"><%# Container.ItemIndex + 1 %></td>
                                <td>
                                    <asp:Image runat="server" CssClass="cat-table-thumb"
                                        ImageUrl='<%# GetCategoryImage(Container.DataItem) %>'
                                        Visible='<%# !string.IsNullOrEmpty(GetCategoryImage(Container.DataItem)) %>' AlternateText="" />
                                    <span runat="server" visible='<%# string.IsNullOrEmpty(GetCategoryImage(Container.DataItem)) %>' style="color: var(--text-muted); font-size: 0.85rem;">—</span>
                                </td>
                                <td style="font-weight: 500;"><%# Eval("CategoryName") %></td>
                                <td style="color: var(--text-muted);"><%# Eval("Description") %></td>
                                <td>
                                    <span class='badge <%# Convert.ToBoolean(Eval("IsActive")) ? "badge-success" : "badge-warning" %>'>
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" CommandArgument='<%# Eval("CategoryID") %>' CssClass="action-btn">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("CategoryID") %>' CssClass="action-btn delete" OnClientClick="return confirm('Are you sure? This will hide the category.');">
                                        <i class="fa-solid fa-trash"></i>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div>
</asp:Content>
