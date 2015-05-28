<?php if(!defined("__XE__"))exit;
if($__Context->oDocument){ ?>
<?php if($__Context->module_info->display_title != 'hide'){ ?><h1><?php echo $__Context->oDocument->getTitle() ?></h1><?php } ?>
<?php echo $__Context->oDocument->getContent($__Context->module_info->display_popupmenu != 'hide') ?>
<?php } ?>
<?php if(!$__Context->oDocument){ ?>
<?php echo $__Context->lang->none_content ?>
<?php } ?>
