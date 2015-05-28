<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/layout/tpl','header.html') ?>
<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/layout/tpl','sub_tab.html') ?>
<table class="x_table x_table-striped x_table-hover dsTg">
	<caption>
		<div class="x_pull-right x_btn-group">
			<button class="x_btn x_active __simple"><?php echo $__Context->lang->simple_view ?></button>
			<button class="x_btn __detail"><?php echo $__Context->lang->detail_view ?></button>
		</div>
	</caption>
	<thead>
		<tr>
			<th scope="col" class="nowr"><?php echo $__Context->lang->layout_name ?></th>
			<th scope="col" class="nowr"><?php echo $__Context->lang->version ?></th>
			<th scope="col" class="nowr"><?php echo $__Context->lang->author ?></th>
			<th scope="col" class="nowr"><?php echo $__Context->lang->path ?></th>
			<th scope="col" class="nowr"><?php echo $__Context->lang->cmd_delete ?></th>
		</tr>
	</thead>
	<tbody>
		<?php if($__Context->layout_list&&count($__Context->layout_list))foreach($__Context->layout_list as $__Context->key=>$__Context->layout){ ?><tr>
			<?php if($__Context->layout->title){ ?>
				<td class="title">
					<p><a href="<?php echo getUrl('act', 'dispLayoutAdminInstanceList', 'type', $__Context->type, 'layout', $__Context->layout->layout) ?>"><?php echo $__Context->layout->title ?></a></p>
					<p><?php echo $__Context->layout->description ?></p>
					<?php if($__Context->layout->need_update == 'Y'){ ?><p class="update">
						<?php echo $__Context->lang->msg_avail_easy_update ?> <a href="<?php echo $__Context->layout->update_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->msg_do_you_like_update ?></a>
					</p><?php } ?>
				</td>
				<td><?php echo $__Context->layout->version ?></td>
				<td>
					<?php if($__Context->layout->author&&count($__Context->layout->author))foreach($__Context->layout->author as $__Context->author){ ?>
						<?php if($__Context->author->homepage){ ?><a href="<?php echo $__Context->author->homepage ?>" target="_blank"><?php echo $__Context->author->name ?></a><?php } ?>
						<?php if(!$__Context->author->homepage){;
echo $__Context->author->name;
} ?>
					<?php } ?>
				</td>
				<td><?php echo $__Context->layout->path ?></td>
				<td class="nowr"><?php if($__Context->layout->remove_url){ ?><a class="x_btn x_btn-link" href="<?php echo $__Context->layout->remove_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->cmd_delete ?></a><?php } ?></td>
			<?php } ?>
			<?php if(!$__Context->layout->title){ ?>
				<td class="title">
					<p><a href="<?php echo getUrl('act', 'dispLayoutAdminInstanceList', 'type', $__Context->type, 'layout', $__Context->layout->layout) ?>"><?php echo $__Context->layout->layout ?></a></p>
					<?php if($__Context->layout->need_update == 'Y'){ ?><p class="update">
						<?php echo $__Context->lang->msg_avail_easy_update ?> <a href="<?php echo $__Context->layout->update_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->msg_do_you_like_update ?></a>
					</p><?php } ?>
				</td>
				<td>-</td>
				<td>-</td>
				<td><?php echo $__Context->layout->path ?></td>
				<td class="nowr"><?php if($__Context->layout->remove_url){ ?><a class="x_btn x_btn-link" href="<?php echo $__Context->layout->remove_url ?>&amp;return_url={urlencodegetRequestUriByServerEnviroment()}"><?php echo $__Context->lang->cmd_delete ?></a><?php } ?></td>
			<?php } ?>
		</tr><?php } ?>
	</tbody>
</table>
