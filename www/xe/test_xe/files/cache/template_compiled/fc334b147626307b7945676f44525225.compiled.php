<?php if(!defined("__XE__"))exit;?><ul class="x_nav x_nav-tabs">
	<li<?php if($__Context->type != 'M'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act', 'dispLayoutAdminInstalledList', 'type', 'P') ?>">PC(<?php echo $__Context->pcLayoutCount ?>)</a></li>
	<li<?php if($__Context->type == 'M'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act', 'dispLayoutAdminInstalledList', 'type', 'M') ?>">Mobile(<?php echo $__Context->mobileLayoutCount ?>)</a></li>
</ul>
<div>
	<a<?php if($__Context->act == 'dispLayoutAdminAllInstanceList'){ ?> class="active"<?php } ?> href="<?php echo getUrl('act', 'dispLayoutAdminAllInstanceList', 'layout_srl', '') ?>"><?php echo $__Context->lang->instance_layout ?></a> <i>|</i>
	<a<?php if($__Context->act == 'dispLayoutAdminInstalledList'){ ?> class="active"<?php } ?> href="<?php echo getUrl('act', 'dispLayoutAdminInstalledList') ?>"><?php echo $__Context->lang->installed_layout ?></a>
</div>
