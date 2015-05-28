<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/widget/tpl','header.html') ?>
<table class="x_table x_table-striped x_table-hover dsTg">
	<caption>
		<strong>All(<?php echo $__Context->tCount ?>)</strong>
		<div class="x_pull-right x_btn-group">
			<button class="x_btn x_active __simple"><?php echo $__Context->lang->simple_view ?></button>
			<button class="x_btn __detail"><?php echo $__Context->lang->detail_view ?></button>
		</div>
	</caption>
	<thead>
		<tr>
			<th scope="col"><?php echo $__Context->lang->widget_name ?></th>
			<th scope="col"><?php echo $__Context->lang->version ?></th>
			<th scope="col"><?php echo $__Context->lang->author ?></th>
			<th scope="col"><?php echo $__Context->lang->path ?></th>
			<th scope="col"><?php echo $__Context->lang->cmd_generate_code ?></th>
			<th scope="col"><?php echo $__Context->lang->cmd_delete ?></th>
		</tr>
	</thead>
	<tbody>
		<?php if($__Context->widget_list&&count($__Context->widget_list))foreach($__Context->widget_list as $__Context->widget){ ?><tr>
			<td class="title">
				<p><strong><?php echo $__Context->widget->title ?></strong></p>
				<p><?php echo $__Context->widget->description ?></p>
				<?php if($__Context->widget->need_update == 'Y'){ ?><p class="update">
					<?php echo $__Context->lang->msg_avail_easy_update ?> <a href="<?php echo $__Context->widget->update_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->msg_do_you_like_update ?></a>
				</p><?php } ?>
			</td>
			<td><?php echo $__Context->widget->version ?></td>
			<td>
				<?php if($__Context->widget->author&&count($__Context->widget->author))foreach($__Context->widget->author as $__Context->author){ ?>
					<?php if($__Context->author->homepage){ ?><a href="<?php echo $__Context->author->homepage ?>" target="_blank"><?php echo $__Context->author->name ?></a><?php } ?>
					<?php if(!$__Context->author->homepage){;
echo $__Context->author->name;
} ?>
				<?php } ?>
			</td>
			<td><?php echo $__Context->widget->path ?></td>
			<td><a class="x_btn x_btn-link" href="<?php echo getUrl('act', 'dispWidgetAdminGenerateCode', 'selected_widget', $__Context->widget->widget) ?>"><?php echo $__Context->lang->cmd_generate_code ?></a></td>
			<td><?php if($__Context->widget->remove_url){ ?><a class="x_btn x_btn-link" href="<?php echo $__Context->widget->remove_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->cmd_delete ?></a><?php } ?></td>
		</tr><?php } ?>
	</tbody>
</table>
