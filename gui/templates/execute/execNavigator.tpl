{* 
TestLink Open Source Project - http://testlink.sourceforge.net/

@filesource	execNavigator.tpl
@internal revisions

*}
{lang_get var="labels"
          s="filter_result,caption_nav_filter_settings,filter_owner,test_plan,filter_on,
             platform,exec_build,btn_apply_filter,build,keyword,filter_tcID,execution_type,
             include_unassigned_testcases,priority,caption_nav_filters,caption_nav_settings"}       


{assign var="cfg_section" value=$smarty.template|basename|replace:".tpl":""}
{config_load file="input_dimensions.conf" section=$cfg_section}

{* ===================================================================== *}
{include file="inc_head.tpl" openHead="yes"}
{include file="inc_ext_js.tpl" bResetEXTCss=1}

{* includes Ext.ux.CollapsiblePanel *}
<script type="text/javascript" src='gui/javascript/ext_extensions.js'></script>

<script type="text/javascript">
treeCfg = { tree_div_id:'tree_div',root_name:"",root_id:0,root_href:"",
            loader:"", enableDD:false, dragDropBackEndUrl:'',children:"" };

treeCfg.root_name='{$gui->ajaxTree->root_node->name|escape:'javascript'}';
treeCfg.root_id={$gui->ajaxTree->root_node->id};
treeCfg.root_href='{$gui->ajaxTree->root_node->href}';
treeCfg.children={$gui->ajaxTree->children};
treeCfg.cookiePrefix='{$gui->ajaxTree->cookiePrefix}';

Ext.onReady(function() 
{
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

	// Use a collapsible panel for filter settings and place a help icon in the header
	var settingsPanel = new Ext.ux.CollapsiblePanel({
						id: 'tl_exec_filter',
						applyTo: 'settings_panel',
						tools: [{
							id: 'help',
							handler: function(event, toolEl, panel) {
								show_help(help_localized_text);
								}
							}]
						});
	var filtersPanel = new Ext.ux.CollapsiblePanel({ 
							id: 'tl_exec_settings',applyTo: 'filter_panel' });
});


/**
 * 
 * internal revisions
 */
function openExportTestPlan(windows_title,tproject_id,tplan_id,platform_id,build_id) 
{
  args = "tproject_id=" + tproject_id + "&tplan_id=" + tplan_id + "&platform_id=" + platform_id + "&build_id=" + build_id;  
  args = args + "&exportContent=tree";
  wref = window.open(fRoot+"lib/plan/planExport.php?"+args,
	                   windows_title,"menubar=no,width=650,height=500,toolbar=no,scrollbars=yes");
  wref.focus();
}
</script>

<script type="text/javascript" src='gui/javascript/execTreeWithMenu.js'></script>
<script type="text/javascript" src="gui/javascript/expandAndCollapseFunctions.js" ></script>
{include file='inc_filter_panel_js.tpl'}

{* 
 * !!!!! IMPORTANT !!!!!
 * Above included file closes <head> tag and opens <body>, so this is not done here.
 *}

<h1 class="title">{$gui->title|escape}</h1>
{include file='inc_filter_panel.tpl'}
{include file="inc_tree_control.tpl"}

<div id="tree_div" style="overflow:auto; height:100%;border:1px solid #c3daf9;"></div>
</body>
</html>