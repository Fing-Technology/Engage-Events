<%@ Import Namespace="System.Globalization"%>
<%@ Import Namespace="DotNetNuke.Entities.Tabs"%>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="Engage.Dnn.Events.Settings" CodeBehind="Settings.ascx.cs" %>
<%@ Register TagPrefix="dnn" TagName="label" Src="~/controls/labelControl.ascx" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<div class="eng-form eng-events-settings">
    <asp:ValidationSummary runat="server" ShowMessageBox="false" ShowSummary="true" CssClass="NormalRed" />
    <fieldset>
        <legend><asp:Literal ID="SpecificSettingsHeaderLiteral" runat="server" /></legend>
        <asp:PlaceHolder ID="SpecificSettingsPlaceholder" runat="server"/>
    </fieldset>
    <fieldset>
        <legend><%= Localize("Common Settings.Header") %></legend>
        <ul class="eng-form-items">
            <li class="eng-form-item eng-tiny eng-featured-setting">
                <dnn:label ResourceKey="FeaturedEventLabel" runat="server" ControlName="FeaturedCheckBox" />
                <asp:CheckBox ID="FeaturedCheckBox" runat="server" />
            </li>
            <li class="eng-form-item eng-tiny eng-hide-full-setting">
                <dnn:label ResourceKey="HideFullEventsLabel" runat="server" ControlName="HideFullEventsCheckBox" />
                <asp:CheckBox ID="HideFullEventsCheckBox" runat="server" />
            </li>
            <li class="eng-form-item eng-tiny eng-allow-reg-by-default-setting">
                <dnn:label ResourceKey="AllowRegistrationsByDefaultLabel" runat="server" ControlName="AllowRegistrationsByDefaultCheckBox" />
                <asp:CheckBox ID="AllowRegistrationsByDefaultCheckBox" runat="server" />
            </li>
            <li class="eng-form-item eng-large eng-categories-setting">
                <dnn:label ResourceKey="CategoriesLabel" runat="server" />
                <telerik:RadTreeView runat="server" ID="CategoriesCheckBoxTreeView" CheckBoxes="True" TriStateCheckBoxes="False" CheckChildNodes="true" OnClientNodeChecked="OnClientNodeChecked" OnClientNodeClicking="OnClientNodeClicking" OnClientNodeClicked="OnClientNodeClicked"/>
                <asp:CustomValidator ID="CategoriesListValidator" runat="server" CssClass="NormalRed" ResourceKey="CategoriesListValidator" Display="None" ForeColor="" />
            </li>
            <li class="eng-form-item eng-large eng-details-display-setting">
                <dnn:label ResourceKey="DetailsDisplayModuleLabel" runat="server" />
                <asp:GridView ID="DetailsDisplayModuleGrid" runat="server" GridLines="None" AutoGenerateColumns="false" CssClass="Normal" UseAccessibleHeader="true">
                    <Columns>
                        <asp:TemplateField HeaderText="Select">
                            <ItemTemplate>
                                <asp:RadioButton ID="DetailsDisplayModuleRadioButton" runat="server" CssClass="Normal" AutoPostBack="true" OnCheckedChanged="DetailsDisplayModuleRadioButton_CheckedChanged"/>
                                <asp:HiddenField ID="TabModuleIdHiddenField" runat="server" Value='<%#((int)Eval("TabModuleID")).ToString(CultureInfo.InvariantCulture) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Page Name">
                            <ItemTemplate>
                                <%#new TabController().GetTab((int)this.Eval("TabID"), this.PortalId, false).TabName %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Tab ID" DataField="TabID"/>
                        <asp:BoundField HeaderText="Module Title" DataField="ModuleName"/>
                        <asp:BoundField HeaderText="Module ID" DataField="ModuleID"/>
                    </Columns>
                    <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="#eeeeee" />
                    <RowStyle BackColor="#f8f8f8" ForeColor="Black" />
                </asp:GridView>
                <asp:CustomValidator ID="DetailsDisplayModuleValidator" runat="server" CssClass="NormalRed" ResourceKey="DetailsDisplayModuleValidator" Display="None" ForeColor="" />
            </li>
        </ul>
    </fieldset>
    <script type="text/javascript">
        function DisableEnableAll(node) {
            var treeView = $find("<%=this.CategoriesCheckBoxTreeView.ClientID %>");
            var nodes = treeView.get_allNodes();

            if (node.get_level() == 0 && node.get_index() == 0) {
                // the root (all categories) node is checked
                var checked = node.get_checked();
                for (var i = 1; i < nodes.length; i++) {
                    var attributes = nodes[i].get_attributes();
                    if (nodes[i].get_nodes() != null) {
                        nodes[i].set_enabled(!checked);
                        nodes[i].set_checked(!checked);
                    }
                }
            }
            else {
                // check if all nodes are unchecked
                var allUnchecked = true;
                for (var i = 1; i < nodes.length; i++) {
                    allUnchecked = allUnchecked && !nodes[i].get_checked();
                }

                if (allUnchecked) {
                    nodes[0].set_checked(true);

                    for (var i = 1; i < nodes.length; i++) {
                        if (nodes[i].get_nodes() != null) {
                            nodes[i].set_enabled(false);
                            nodes[i].set_checked(false);
                        }
                    }
                }
            }
        }

        function OnClientNodeClicked(sender, event) {
            var node = event.get_node();
            node.set_selected(false);
            return false;
        }

        function OnClientNodeClicking(sender, event) {
            var node = event.get_node();
            node.set_checked(!node.get_checked());
            node.set_selected(false);
            DisableEnableAll(node);
            return false;
        }

        function OnClientNodeChecked(sender, event) {
            var node = event.get_node();
            DisableEnableAll(node);
        }   
    </script>
</div>
<div class="eng-end-form"></div>