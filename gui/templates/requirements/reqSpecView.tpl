{* 
TestLink Open Source Project - http://testlink.sourceforge.net/

view a requirement specification

@filesource	reqSpecView.tpl
@internal revisions
@since 2.0
*}
{lang_get var="labels" s="type_not_configured,type,scope,req_total,by,title,title_last_mod,revision,
						  title_created,no_records_found,commit_title,please_add_revision_log"}

{$cfg_section=$smarty.template|basename|replace:".tpl":""}
{config_load file="input_dimensions.conf" section=$cfg_section}

{$bn=$smarty.template|basename}
{$buttons_template=$smarty.template|replace:"$bn":"inc_btn_$bn"}

{$reqSpecID=$gui->req_spec_id}
{$tprojectID=$gui->tproject_id}
{$req_module='lib/requirements/'}
{$url_args="reqEdit.php?doAction=create&tproject_id=$tprojectID&req_spec_id="}
{$req_edit_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqImport.php?req_spec_id="}
{$req_import_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqExport.php?req_spec_id="}
{$req_export_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqImport.php?scope=branch&req_spec_id="}
{$req_spec_import_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqExport.php?scope=branch&req_spec_id="}
{$req_spec_export_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqEdit.php?doAction=reorder&amp;req_spec_id="}
{$req_reorder_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqEdit.php?doAction=createTestCases&amp;req_spec_id="}
{$req_create_tc_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqSpecEdit.php?doAction=createChild&amp;reqParentID="}
{$req_spec_new_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqSpecEdit.php?doAction=copyRequirements&amp;req_spec_id="}
{$req_spec_copy_req_url="$basehref$req_module$url_args$reqSpecID"}

{$url_args="reqSpecEdit.php?doAction=copy&amp;req_spec_id="}
{$req_spec_copy_url="$basehref$req_module$url_args$reqSpecID"}


{* used on inc_btn_reqSpecView.tpl -> buttons_template smarty variable *}
{lang_get s='warning_delete_req_spec' var="warning_msg"}
{lang_get s='delete' var="del_msgbox_title"}
{lang_get s='warning_freeze_spec' var="freeze_warning_msg"}
{lang_get s='freeze' var="freeze_msgbox_title"}

{include file="inc_head.tpl" openHead="yes" jsValidate="yes"}
{include file="inc_action_onclick.tpl"}

<script type="text/javascript">
/* All this stuff is needed for logic contained in inc_action_onclick.tpl */
/* target_action name can not be CHANGED */
var target_action=fRoot+'{$req_module}reqSpecEdit.php?doAction=doDelete&tproject_id={$tprojectID}&req_spec_id=';

/* TICKET 4661 */
var log_box_title = "{$labels.commit_title|escape:'javascript'}";
var log_box_text = "{$labels.please_add_revision_log|escape:'javascript'}";


/**
 * 
 */
function freeze_req_spec(btn, text, o_id) 
{
	var my_action=fRoot+'lib/requirements/reqSpecEdit.php?doAction=doFreeze&tproject_id={$tprojectID}&req_spec_id=';
	if( btn == 'yes' ) 
	{
		my_action = my_action+o_id;
		window.location=my_action;
	}
}
var pF_freeze_req_spec = freeze_req_spec;


function momo(a)
{
 var b=a;
}


/**
 * 
 * @since 2.0
 * TICKET 4703
 */
function tip4log(itemID)
{
	var fUrl = fRoot+'lib/ajax/getreqspeclog.php?item_id=';
	new Ext.ToolTip({
        target: 'tooltip-'+itemID,
        width: 500,
        autoLoad:{ url: fUrl+itemID },
        dismissDelay: 0,
        trackMouse: true
    });
}


/**
 * 
 * @since 2.0
 * TICKET 4661
 */
function ask4log(fid,tid)
{
	var target = document.getElementById(tid);
	var my_form = document.getElementById(fid);

	Ext.Msg.prompt(	log_box_title, log_box_text, 
					function(btn, text)
					{
						if (btn == 'ok')
   						{
       						target.value=text;
       						my_form.submit();
   						}
					},this,true);    
	return false;    
} 

{* 
Developer NOTICE: on smarty 3.0 and up:
if we remove space in "{ tip4log(" smarty compiler will generate an error because
when it found a curly brackets WITHOUT space, consider this SMARTY CODE
not JS code
*}
Ext.onReady(function(){ tip4log({$gui->req_spec.revision_id}); });
</script>
</head>

<body {$body_onload} onUnload="storeWindowSize('ReqSpecPopup')" >
<h1 class="title">
  {if isset($gui->direct_link)}{$tlImages.toggle_direct_link} &nbsp;{/if}
  {$gui->main_descr|escape}
  {if $gui->req_spec.id}
	{include file="inc_help.tpl" helptopic="hlp_requirementsCoverage" show_help_icon=true}
  {/if}
</h1>

<div class="workBack">
   {if isset($gui->direct_link)}
   <div class="direct_link" style='display:none'><a href="{$gui->direct_link}" target="_blank">{$gui->direct_link}</a></div>
   {/if}

{if $gui->req_spec.id}
{include file="./requirements/$buttons_template" args_reqspec_id=$reqSpecID}
<table class="simple">
	<tr>
		<th>{$gui->main_descr|escape}</th>
	</tr>
	
	{* TICKET 4703 *}
	<tr>
		<td class="bold" id="tooltip-{$gui->req_spec.revision_id}">
			{$labels.revision}{$smarty.const.TITLE_SEP}{$gui->req_spec.revision}
			 <img src="{$tlImages.log_message_small}" style="border:none" />
		</td>
	</tr>

	<tr>
	  <td>{$labels.type}{$smarty.const.TITLE_SEP}
	  {$req_spec_type=$gui->req_spec.type}
	  {if isset($gui->reqSpecTypeDomain.$req_spec_type)}
	    {$gui->reqSpecTypeDomain.$req_spec_type}
	  {else}
	    {$labels.type_not_configured}  
	  {/if}
	  </td>
	</tr>
	<tr>
		<td>
			<fieldset class="x-fieldset x-form-label-left"><legend class="legend_container">{$labels.scope}</legend>
			{$gui->req_spec.scope}
			</fieldset>
		</td>
	</tr>
  {if $gui->external_req_management && $gui->req_spec.total_req != 0}
  	<tr>
  		<td>{$labels.req_total}{$smarty.const.TITLE_SEP}{$gui->req_spec.total_req}</td>
   	</tr>
  {/if}
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
  			{$gui->cfields}
  		</td>
	</tr>
	<tr class="time_stamp_creation">
		<td colspan="2">
	    	  {$labels.title_created}&nbsp;{localize_timestamp ts=$gui->req_spec.creation_ts}&nbsp;
	      	{$labels.by}&nbsp;{$gui->req_spec.author|escape}
	  	</td>
	 </tr>
  {if $gui->req_spec.modifier != ""}
    <tr class="time_stamp_creation">
    	<td colspan="2">
    		{$labels.title_last_mod}&nbsp;{localize_timestamp ts=$gui->req_spec.modification_ts}
		  	&nbsp;{$labels.by}&nbsp;{$gui->req_spec.modifier|escape}
    	</td>
    </tr>
  {/if}
</table>

{$downloadOnly=true}
{if $gui->grants->req_mgmt == 'yes'}
	{$downloadOnly=false}
{/if}
{include file="inc_attachments.tpl" 
         attach_id=$gui->req_spec.id  
         attach_tableName="req_specs"
         attach_attachmentInfos=$gui->attachments  
         attach_downloadOnly=$downloadOnly}

{else}
	{$labels.no_records_found}
{/if}

</div>
{if isset($gui->refreshTree) && $gui->refreshTree} {$tlRefreshTreeJS} {/if}
</body>
</html>