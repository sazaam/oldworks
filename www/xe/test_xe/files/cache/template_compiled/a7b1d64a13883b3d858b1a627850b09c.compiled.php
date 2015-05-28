<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/member/skins/default','common_header.html') ?>
<h1><?php echo $__Context->member_title = $__Context->lang->cmd_view_scrapped_document ?></h1>
<table class="table table-striped table-hover">
	<caption>Total: <?php echo number_format($__Context->total_count) ?>, Page: <?php echo number_format($__Context->page) ?>/<?php echo number_format($__Context->total_page) ?></caption>
	<thead>
		<tr>
			<th><?php echo $__Context->lang->no ?></th>
			<th class="title"><?php echo $__Context->lang->title ?></th>
			<th><?php echo $__Context->lang->writer ?></th>
			<th><?php echo $__Context->lang->date ?></th>
			<th><?php echo $__Context->lang->cmd_delete ?></th>
		</tr>
	</thead>
	<tbody>
		<?php if($__Context->document_list&&count($__Context->document_list))foreach($__Context->document_list as $__Context->no=>$__Context->val){ ?><tr>
			<td><?php echo $__Context->no ?></td>
			<td class="title"><a href="<?php echo getUrl('','document_srl',$__Context->val->document_srl) ?>" onclick="window.open(this.href);return false;"><?php echo htmlspecialchars($__Context->val->title, ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?></a></td>
			<td><a href="#popup_menu_area" class="member_<?php echo $__Context->val->target_member_srl ?>"><?php echo $__Context->val->nick_name ?></a></td>
			<td><?php echo zdate($__Context->val->regdate, "Y-m-d") ?></td>
			<td><button type="button" class="text" onclick="doDeleteScrap(<?php echo $__Context->val->document_srl ?>);"><?php echo $__Context->lang->cmd_delete ?></button></td>
		</tr><?php } ?>
	</tbody>
</table>
<div class="pagination pagination-centered">
	<ul>
		<li><a href="<?php echo getUrl('page','','module_srl','') ?>">&laquo; <?php echo $__Context->lang->first_page ?></a></li>
		<?php while($__Context->page_no = $__Context->page_navigation->getNextPage()){ ?>
		<li<?php if($__Context->page == $__Context->page_no){ ?> class="active"<?php } ?>><a href="<?php echo getUrl('page',$__Context->page_no,'module_srl','') ?>"><?php echo $__Context->page_no ?></a></li>
		<?php } ?>
		<li><a href="<?php echo getUrl('page',$__Context->page_navigation->last_page,'module_srl','') ?>"><?php echo $__Context->lang->last_page ?> &raquo;</a></li>
	</ul>
</div>
<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/member/skins/default','common_footer.html') ?>
