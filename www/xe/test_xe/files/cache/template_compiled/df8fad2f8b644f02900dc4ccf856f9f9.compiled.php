<?php if(!defined("__XE__"))exit;?><script>
xe.lang.msg_empty_search_target = '<?php echo $__Context->lang->msg_empty_search_target ?>';
xe.lang.msg_empty_search_keyword = '<?php echo $__Context->lang->msg_empty_search_keyword ?>';
</script>
<!--#Meta:modules/file/tpl/js/file_admin.js--><?php $__tmp=array('modules/file/tpl/js/file_admin.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<form id="fo_list" action="./" method="post"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="act" value="<?php echo $__Context->act ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<input type="hidden" name="module" value="file" />
	<div class="x_page-header">
		<h1><?php echo $__Context->lang->file ?> <a class="x_icon-question-sign" href="./admin/help/index.html#UMAN_content_file" target="_blank"><?php echo $__Context->lang->help ?></a></h1>
	</div>
	<?php if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'modules/file/tpl/file_list/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
		<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
	</div><?php } ?>
	<table id="fileListTable" class="x_table x_table-striped x_table-hover">
		<caption>
			<a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispFileAdminList') ?>"<?php if($__Context->search_keyword == ''){ ?> class="active"<?php } ?>><?php echo $__Context->lang->all;
if($__Context->search_keyword == ''){ ?>(<?php echo number_format($__Context->total_count) ?>)<?php } ?></a>
			<i>|</i>
			<a href="<?php echo getUrl('search_target','isvalid','search_keyword','Y') ?>"<?php if($__Context->search_target == 'isvalid' && $__Context->search_keyword == 'Y'){ ?> class="active"<?php } ?>><?php echo $__Context->lang->is_valid;
if($__Context->search_target == 'isvalid' && $__Context->search_keyword == 'Y'){ ?>(<?php echo number_format($__Context->total_count) ?>)<?php } ?></a>
			<i>|</i>
			<a href="<?php echo getUrl('search_target','isvalid','search_keyword','N') ?>"<?php if($__Context->search_target == 'isvalid' && $__Context->search_keyword == 'N'){ ?> class="active"<?php } ?>><?php echo $__Context->lang->is_stand_by;
if($__Context->search_target == 'isvalid' && $__Context->search_keyword == 'N'){ ?>(<?php echo number_format($__Context->total_count) ?>)<?php } ?></a>
			<a class="x_icon-question-sign" href="./admin/help/index.html#UMAN_faq_file_status" target="_blank"><?php echo $__Context->lang->help ?></a>
			
			<span class="x_pull-right"><a href="#listManager" class="x_btn modalAnchor" onclick="getFileList();"><?php echo $__Context->lang->delete ?></a></span>
		</caption>
		<thead>
			<tr>
				<th scope="col"><?php echo $__Context->lang->file ?></th>
				<th scope="col" class="nowr"><?php echo $__Context->lang->file_size ?></th>
				<th scope="col" class="nowr"><?php echo $__Context->lang->cmd_download ?></th>
				<th scope="col" class="nowr"><?php echo $__Context->lang->author ?></th>
				<th scope="col" class="nowr"><?php echo $__Context->lang->date ?></th>
				<th scope="col" class="nowr"><?php echo $__Context->lang->ipaddress ?></th>
				<th scope="col" class="nowr"><?php echo $__Context->lang->status ?></th>
				<th scope="col"><input type="checkbox" data-name="cart" title="Check All" /></th>
			</tr>
		</thead>
		<tbody>
			<?php if($__Context->file_list&&count($__Context->file_list))foreach($__Context->file_list as $__Context->no => $__Context->val){ ?>
				<!-- one document start -->
				<?php if($__Context->val->upload_target_srl != $__Context->cur_upload_target_srl){ ?>
					<?php if($__Context->val->upload_target_type == 'com'){ ?>
						<?php  $__Context->document_srl = $__Context->val->target_document_srl ?>
						<?php  $__Context->move_uri = getUrl('', 'document_srl', $__Context->document_srl).'#comment_'.$__Context->val->upload_target_srl ?>
					<?php }elseif($__Context->val->upload_target_type == 'doc'){ ?>
						<?php  $__Context->document_srl = $__Context->val->upload_target_srl ?>
						<?php  $__Context->move_uri = getUrl('', 'document_srl', $__Context->document_srl) ?>
					<?php } ?>
					<?php  $__Context->cur_upload_target_srl = $__Context->val->upload_target_srl ?>
			<tr>
				<th colspan="8" scope="col">
					<?php if(!$__Context->val->upload_target_type){ ?>
						<?php if($__Context->val->isvalid=='Y'){ ?>
							<?php echo $__Context->lang->is_valid ?>
						<?php }else{ ?>
							<?php echo $__Context->lang->is_stand_by ?>
						<?php } ?>
					<?php }else{ ?>
						<?php if($__Context->val->upload_target_type == 'com'){ ?>[<?php echo $__Context->lang->comment ?>] <?php } ?>
						<?php if($__Context->val->upload_target_type == 'mod'){ ?>[<?php echo $__Context->lang->module ?>] <?php } ?>
						<?php if($__Context->val->upload_target_type == 'doc' && $__Context->document_list[$__Context->document_srl] && $__Context->document_list[$__Context->document_srl]->get('module_srl') == $__Context->document_list[$__Context->document_srl]->get('member_srl')){ ?>[<?php echo $__Context->lang->cmd_temp_save ?>] <?php } ?>
						<?php if($__Context->val->upload_target_type == 'doc' && $__Context->document_list[$__Context->document_srl] && $__Context->document_list[$__Context->document_srl]->get('module_srl') == 0){ ?>[<?php echo $__Context->lang->cmd_trash ?>] <?php } ?>
						<a href="<?php echo getUrl('', 'mid', $__Context->module_list[$__Context->val->module_srl]->mid) ?>" target="_blank"><?php echo $__Context->module_list[$__Context->val->module_srl]->browser_title ?></a>
						<?php if($__Context->document_list[$__Context->document_srl] && ($__Context->val->upload_target_type == 'doc' || $__Context->val->upload_target_type == 'com')){ ?>
						 - <?php if($__Context->document_list[$__Context->document_srl]->get('module_srl') != $__Context->document_list[$__Context->document_srl]->get('member_srl')){ ?><a href="<?php echo $__Context->move_uri ?>" target="_blank"><?php echo $__Context->document_list[$__Context->document_srl]->getTitle() ?></a><?php }else{;
echo $__Context->document_list[$__Context->document_srl]->getTitle();
} ?>
						<?php } ?>
					<?php } ?>
				</th>
			</tr>
				<?php } ?>
				<!-- one document end -->
			<tr>
				<td><a href="<?php echo htmlspecialchars_decode($__Context->val->download_url) ?>"><?php echo htmlspecialchars($__Context->val->source_filename, ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?></a></td>
				<td class="nowr"><?php echo FileHandler::filesize($__Context->val->file_size) ?></td>
				<td class="nowr"><?php echo $__Context->val->download_count ?></td>
				<td class="nowr">
					<?php if($__Context->val->upload_target_type == 'doc' && $__Context->document_list[$__Context->document_srl]){ ?>
					<a href="#popup_menu_area" class="member_<?php echo $__Context->document_list[$__Context->document_srl]->get('member_srl') ?>"><?php echo $__Context->document_list[$__Context->document_srl]->getNickName() ?></a>
					<?php }elseif($__Context->val->upload_target_type == 'com' && $__Context->comment_list[$__Context->val->upload_target_srl]){ ?>
					<a href="#popup_menu_area" class="member_<?php echo $__Context->comment_list[$__Context->val->upload_target_srl]->get('member_srl') ?>"><?php echo $__Context->comment_list[$__Context->val->upload_target_srl]->getNickName() ?></a>
					<?php }else{ ?>
					<a href="#popup_menu_area" class="member_<?php echo $__Context->val->member_srl ?>"><?php echo $__Context->val->nick_name ?></a>
					<?php } ?>
				</td>
				<td class="nowr"><?php echo zdate($__Context->val->regdate,"Y-m-d H:i") ?></td>
				<td class="nowr"><a href="<?php echo getUrl('search_target','ipaddress','search_keyword',$__Context->val->ipaddress) ?>"><?php echo $__Context->val->ipaddress ?></a></td>
				<td class="nowr"><?php if($__Context->val->isvalid=='Y'){;
echo $__Context->lang->is_valid;
}else{;
echo $__Context->lang->is_stand_by;
} ?></td>
				<td>
					<input type="checkbox" name="cart" value="<?php echo $__Context->val->file_srl ?>" />
				</td>
			</tr>
			<?php } ?>
			<?php if(!$__Context->file_list){ ?><tr>
				<td><?php echo $__Context->lang->no_files ?></td>
			</tr><?php } ?>
		</tbody>
	</table>
	<span class="x_pull-right">
		<a href="#listManager" class="x_btn modalAnchor" onclick="getFileList();"><?php echo $__Context->lang->delete ?></a>
	</span>
</form>
<form action="" class="x_pagination"><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<input type="hidden" name="error_return_url" value="" />
	<input type="hidden" name="module" value="<?php echo $__Context->module ?>" />
	<input type="hidden" name="act" value="<?php echo $__Context->act ?>" />
  	<?php if($__Context->search_keyword){ ?><input type="hidden" name="search_keyword" value="<?php echo $__Context->search_keyword ?>" /><?php } ?>
  	<?php if($__Context->search_target){ ?><input type="hidden" name="search_target" value="<?php echo $__Context->search_target ?>" /><?php } ?>
	<ul>
		<li<?php if(!$__Context->page || $__Context->page == 1){ ?> class="x_disabled"<?php } ?>><a href="<?php echo getUrl('page', '') ?>">&laquo; <?php echo $__Context->lang->first_page ?></a></li>
		<?php if($__Context->page_navigation->first_page != 1 && $__Context->page_navigation->first_page + $__Context->page_navigation->page_count > $__Context->page_navigation->last_page - 1 && $__Context->page_navigation->page_count != $__Context->page_navigation->total_page){ ?>
		<?php $__Context->isGoTo = true ?>
		<li>
			<a href="#goTo" data-toggle title="<?php echo $__Context->lang->cmd_go_to_page ?>">&hellip;</a>
			<?php if($__Context->isGoTo){ ?><span id="goTo" class="x_input-append">
				<input type="number" min="1" max="<?php echo $__Context->page_navigation->last_page ?>" required name="page" title="<?php echo $__Context->lang->cmd_go_to_page ?>" />
				<button type="submit" class="x_add-on">Go</button>
			</span><?php } ?>
		</li>
		<?php } ?>
		<?php while($__Context->page_no = $__Context->page_navigation->getNextPage()){ ?>
		<?php $__Context->last_page = $__Context->page_no ?>
		<li<?php if($__Context->page_no == $__Context->page){ ?> class="x_active"<?php } ?>><a  href="<?php echo getUrl('page', $__Context->page_no) ?>"><?php echo $__Context->page_no ?></a></li>
		<?php } ?>
		<?php if($__Context->last_page != $__Context->page_navigation->last_page && $__Context->last_page + 1 != $__Context->page_navigation->last_page){ ?>
		<?php $__Context->isGoTo = true ?>
		<li>
			<a href="#goTo" data-toggle title="<?php echo $__Context->lang->cmd_go_to_page ?>">&hellip;</a>
			<?php if($__Context->isGoTo){ ?><span id="goTo" class="x_input-append">
				<input type="number" min="1" max="<?php echo $__Context->page_navigation->last_page ?>" required name="page" title="<?php echo $__Context->lang->cmd_go_to_page ?>" />
				<button type="submit" class="x_add-on">Go</button>
			</span><?php } ?>
		</li>
		<?php } ?>
		<li<?php if($__Context->page == $__Context->page_navigation->last_page){ ?> class="x_disabled"<?php } ?>><a href="<?php echo getUrl('page', $__Context->page_navigation->last_page) ?>" title="<?php echo $__Context->page_navigation->last_page ?>"><?php echo $__Context->lang->last_page ?> &raquo;</a></li>
	</ul>
</form>
<form action="./" method="get" onsubmit="return checkSearch(this)" class="search center x_input-append"><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<input type="hidden" name="module" value="<?php echo $__Context->module ?>" />
	<input type="hidden" name="act" value="<?php echo $__Context->act ?>" />
	<input type="hidden" name="module_srl" value="<?php echo $__Context->module_srl ?>" />
	<input type="hidden" name="error_return_url" value="" />
	<select name="search_target" title="<?php echo $__Context->lang->search_target ?>" style="margin-right:4px">
		<?php if($__Context->lang->file_search_target_list&&count($__Context->lang->file_search_target_list))foreach($__Context->lang->file_search_target_list as $__Context->key => $__Context->val){ ?>
		<option value="<?php echo $__Context->key ?>" <?php if($__Context->search_target==$__Context->key){ ?>selected="selected"<?php } ?>><?php echo $__Context->val ?></option>
		<?php } ?>
	</select>
	<input type="search" name="search_keyword" value="<?php echo htmlspecialchars($__Context->search_keyword, ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" />
	<button type="submit" class="x_btn x_btn-inverse"><?php echo $__Context->lang->cmd_search ?></button>
	<a href="<?php echo getUrl('','module',$__Context->module,'act',$__Context->act) ?>" class="x_btn"><?php echo $__Context->lang->cmd_cancel ?></a>
</form>
<?php Context::addJsFile("modules/file/ruleset/deleteChecked.xml", FALSE, "", 0, "body", TRUE, "") ?><form  action="./" method="post" class="x_modal" id="listManager"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" /><input type="hidden" name="ruleset" value="deleteChecked" />
	<input type="hidden" name="module" value="file" />
	<input type="hidden" name="act" value="procFileAdminDeleteChecked" />
	<input type="hidden" name="page" value="<?php echo $__Context->page ?>" />
	<input type="hidden" name="xe_validator_id" value="modules/file/tpl/file_list/1" />
	<div class="x_modal-header">
		<h1><?php echo $__Context->lang->file_manager ?>: <?php echo $__Context->lang->delete ?></h1>
	</div>
	<div class="x_modal-body">
		<table width="100%" id="fileManageListTable" class="x_table x_table-striped x_table-hover">
			<caption>
				<strong><?php echo $__Context->lang->selected_file ?> <span id="selectedFileCount"></span></strong>
			</caption>
			<thead>
				<tr>
					<th scope="col"><?php echo $__Context->lang->file ?></th>
					<th scope="col" class="nowr"><?php echo $__Context->lang->file_size ?></th>
					<th scope="col" class="nowr"><?php echo $__Context->lang->status ?></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<div class="x_modal-footer">
		<button type="submit" class="x_btn x_btn-inverse"><?php echo $__Context->lang->cmd_delete ?></button>
	</div>
</form>
<script>
jQuery(function($){
	// Modal anchor activation
	var $docTable = $('#fileListTable');
	$docTable.find(':checkbox').change(function(){
		var $modalAnchor = $('a.modalAnchor');
		if($docTable.find('tbody :checked').length == 0){
			$modalAnchor.removeAttr('href').addClass('x_disabled');
		} else {
			$modalAnchor.attr('href','#listManager').removeClass('x_disabled');
		}
	}).change();
	// Button action
	$('a.modalAnchor').bind('before-open.mw', function(){
		if($docTable.find('tbody :checked').length == 0){
			$('body').css('overflow','auto');
			alert('<?php echo $__Context->lang->msg_file_cart_is_null ?>');
			return false;
		}
	});
});
</script>
