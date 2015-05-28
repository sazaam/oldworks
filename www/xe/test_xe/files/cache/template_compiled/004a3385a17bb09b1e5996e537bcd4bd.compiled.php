<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/member/skins/default','common_header.html') ?>
<h1><?php echo $__Context->member_title = $__Context->lang->cmd_view_own_document  ?></h1>
<table class="table table-striped table-hover">
	<caption>
		Total: <?php echo number_format($__Context->total_count) ?>, Page <?php echo number_format($__Context->page) ?>/<?php echo number_format($__Context->total_page) ?>
		<span class="pull-right">
			<a href="<?php echo getUrl('','module','module','act','dispModuleSelectList','id','target_module','type','single') ?>" class="btn" onclick="popopen(this.href,'ModuleSelect');return false;"><?php echo $__Context->lang->cmd_find_module ?></a>
			<?php if($__Context->selected_module_srl){ ?><a href="<?php echo getUrl('selected_module_srl','') ?>" class="btn"><?php echo $__Context->lang->cmd_cancel ?></a><?php } ?>
		</span>
	</caption>
	<thead>
		<tr>
			<th><?php echo $__Context->lang->no ?></th>
			<th class="title"><?php echo $__Context->lang->title ?></th>
			<th><?php echo $__Context->lang->date ?></th>
			<th><?php echo $__Context->lang->readed_count ?></th>
			<th><?php echo $__Context->lang->voted_count ?></th>
		</tr>
	</thead>
	<tbody>
		<?php if($__Context->document_list&&count($__Context->document_list))foreach($__Context->document_list as $__Context->no=>$__Context->oDocument){ ?><tr>
			<td><?php echo $__Context->no ?></td>
			<td class="title">
				<a href="<?php echo getUrl('','document_srl',$__Context->oDocument->document_srl) ?>" onclick="window.open(this.href);return false;"><?php echo $__Context->oDocument->getTitleText() ?></a>
				<?php if($__Context->oDocument->getCommentCount()){ ?>
					[<?php echo $__Context->oDocument->getCommentCount() ?>]
				<?php } ?>
	
				<?php if($__Context->oDocument->getTrackbackCount()){ ?>
					[<?php echo $__Context->oDocument->getTrackbackCount() ?>]
				<?php } ?>
			</td>
			<td><?php echo $__Context->oDocument->getRegdate("Y-m-d") ?></td>
			<td><?php echo $__Context->oDocument->get('readed_count') ?></td>
			<td><?php echo $__Context->oDocument->get('voted_count') ?></td>
		</tr><?php } ?>
	</tbody>
</table>
<div class="pagination pagination-centered">
	<ul>
		<li><a href="<?php echo getUrl('page','','module_srl','') ?>" class="direction">&laquo; <?php echo $__Context->lang->first_page ?></a></li> 
		<?php while($__Context->page_no = $__Context->page_navigation->getNextPage()){ ?>
		<li<?php if($__Context->page == $__Context->page_no){ ?> class="active"<?php } ?>><a href="<?php echo getUrl('page',$__Context->page_no,'module_srl','') ?>"><?php echo $__Context->page_no ?></a></li>
		<?php } ?>
		<li><a href="<?php echo getUrl('page',$__Context->page_navigation->last_page,'module_srl','') ?>" class="direction"><?php echo $__Context->lang->last_page ?> &raquo;</a></li>
	</ul>
</div>
<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/member/skins/default','common_footer.html') ?>
