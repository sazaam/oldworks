<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/communication/skins/default','common_header.html') ?>
<?php require_once('./classes/xml/XmlJsFilter.class.php');$__xmlFilter=new XmlJsFilter('modules/communication/skins/default/filter','delete_checked_message.xml');$__xmlFilter->compile(); ?>
<?php require_once('./classes/xml/XmlJsFilter.class.php');$__xmlFilter=new XmlJsFilter('modules/communication/skins/default/filter','update_allow_message.xml');$__xmlFilter->compile(); ?>
<div class="btnArea">
	<form action="./" method="GET" style="margin:0;display:inline-block;*display:inline;zoom:1" onsubmit="location.href=current_url.setQuery('message_srl','').setQuery('message_type',this.message_box.options[this.message_box.selectedIndex].value); return false;"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="act" value="<?php echo $__Context->act ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
		<select name="message_box" style="margin:0">
			<?php if($__Context->lang->message_box&&count($__Context->lang->message_box))foreach($__Context->lang->message_box as $__Context->key=>$__Context->val){ ?><option<?php if($__Context->key==$__Context->message_type){ ?> selected="selected"<?php } ?> value="<?php echo $__Context->key ?>" ><?php echo $__Context->val ?></option><?php } ?>
		</select>
		<input type="submit" value="<?php echo $__Context->lang->cmd_select ?>" class="btn" />
	</form>
	<form action="./" method="POST" style="margin:0;display:inline-block;*display:inline;zoom:1"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
		<input type="hidden" name="module" value="communication" />
		<input type="hidden" name="act" value="procCommunicationUpdateAllowMessage" />
		<input type="hidden" name="message_type" value="<?php echo $__Context->message_type ?>" />
		<select name="allow_message" style="margin:0">
			<?php if($__Context->lang->allow_message_type&&count($__Context->lang->allow_message_type))foreach($__Context->lang->allow_message_type as $__Context->key=>$__Context->val){ ?><option value="<?php echo $__Context->key ?>"<?php if($__Context->logged_info->allow_message==$__Context->key){ ?> selected="selected"<?php } ?>><?php echo $__Context->val ?></option><?php } ?>
		</select>
		<input type="submit" value="<?php echo $__Context->lang->cmd_save ?>" class="btn">
	</form>
</div>
<?php if($__Context->message){ ?><table class="table table-striped table-hover">
	<tr>
		<th><?php echo $__Context->message->title ?></th>
	</tr>
	<tr>
		<td>
			<a href="popup_menu_area" class="member_<?php echo $__Context->message->member_srl ?>"><?php echo $__Context->message->nick_name ?></a>
			<?php echo zdate($__Context->message->regdate, "Y.m.d H:i") ?>
		</td>
	</tr>
	<tr>
		<td class="xe_content">
			<?php echo $__Context->message->content ?>
		</td>
	</tr>
</table><?php } ?>
<?php if($__Context->message){ ?><div class="btnArea btn-group" style="margin-bottom:20px">
	<?php if($__Context->message->message_type != 'S' && $__Context->message->member_srl != $__Context->logged_info->member_srl){ ?><button class="btn" type="button" onclick="doSendMessage('<?php echo $__Context->message->sender_srl ?>','<?php echo $__Context->message->message_srl ?>');"><?php echo $__Context->lang->cmd_reply_message ?></button><?php } ?>
	<?php if($__Context->message->message_type == 'R'){ ?><button class="btn" type="button" onclick="doStoreMessage('<?php echo $__Context->message->message_srl ?>');"><?php echo $__Context->lang->cmd_store ?></button><?php } ?>
	<button class="btn" type="button" onclick="doDeleteMessage('<?php echo $__Context->message->message_srl ?>');"><?php echo $__Context->lang->cmd_delete ?></button>
</div><?php } ?>
<form action="./" method="get" id="fo_message_list"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<input type="hidden" name="module" value="communication" />
	<input type="hidden" name="act" value="procCommunicationDeleteMessages" />
	<input type="hidden" name="message_type" value="<?php echo $__Context->message_type ?>" />
	<table class="table table-striped table-hover">
		<thead>
			<tr>
				<th scope="col" class="title"><?php echo $__Context->lang->title ?></th>
				<th scope="col">
					<?php if($__Context->message_type == "S"){ ?>
					<?php echo $__Context->lang->receiver ?>
					<?php }else{ ?>
					<?php echo $__Context->lang->sender ?>
					<?php } ?>
				</th>
				<th scope="col"><?php echo $__Context->lang->regdate ?></th>
				<th scope="col"><?php echo $__Context->lang->readed_date ?></th>
				<th scope="col"><input name="check_all" type="checkbox" onclick="XE.checkboxToggleAll('message_srl_list[]', {wrap:'fo_message_list'})"/></th>
			</tr>
		</thead>
		<tbody>
			<?php if($__Context->message_list&&count($__Context->message_list))foreach($__Context->message_list as $__Context->no=>$__Context->val){ ?><tr>
				<td class="title">
					<?php if($__Context->val->readed=='Y'){ ?><a href="<?php echo getUrl('message_srl',$__Context->val->message_srl) ?>"><?php echo $__Context->val->title ?></a><?php } ?>
					<?php if($__Context->val->readed!='Y'){ ?><a href="<?php echo getUrl('message_srl',$__Context->val->message_srl) ?>"><strong><?php echo $__Context->val->title ?></strong></a><?php } ?>
				</td>
				<td>
					<a href="#popup_menu_area" class="member_<?php echo $__Context->val->member_srl ?>"><?php echo $__Context->val->nick_name ?></a>
				</td>
				<td> 
					<?php echo zdate($__Context->val->regdate,"Y-m-d") ?>
				</td>
				<td><?php if($__Context->val->readed=='Y'){;
echo zdate($__Context->val->readed_date,"Y-m-d H:i");
} ?>&nbsp;</td>
				<td><input name="message_srl_list[]" type="checkbox" value="<?php echo $__Context->val->message_srl ?>" /></td>
			</tr><?php } ?>
		</tbody>
	</table>
	<div class="btnArea">
		<input type="submit" class="btn" value="<?php echo $__Context->lang->cmd_delete ?>" />
	</div>
</form>
<div class="pagination pagination-centered">
	<ul>
		<li><a href="<?php echo getUrl('page','','document_srl','') ?>" class="direction">&laquo; <?php echo $__Context->lang->first_page ?></a></li>
		<?php while($__Context->page_no = $__Context->page_navigation->getNextPage()){ ?>
		<li<?php if($__Context->page == $__Context->page_no){ ?> class="active"<?php } ?>><a href="<?php echo getUrl('page',$__Context->page_no,'document_srl','') ?>"><?php echo $__Context->page_no ?></a></li>
		<?php } ?>
		<li><a href="<?php echo getUrl('page',$__Context->page_navigation->last_page,'document_srl','') ?>" class="direction"><?php echo $__Context->lang->last_page ?> &raquo;</a></li>
	</ul>
</div>
<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/communication/skins/default','common_footer.html') ?>
