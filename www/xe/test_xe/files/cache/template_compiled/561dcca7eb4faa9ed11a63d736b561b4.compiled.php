<?php if(!defined("__XE__"))exit;?><!--#Meta:addons/cameron_plugin/js/cameron_plugin.js--><?php $__tmp=array('addons/cameron_plugin/js/cameron_plugin.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:addons/cameron_plugin/css/cameron_plugin.css--><?php $__tmp=array('addons/cameron_plugin/css/cameron_plugin.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php if(!$__Context->addon_info->positionx){;
$__Context->addon_info->positionx='left';
} ?>
<div<?php if(!$__Context->addon_info->positiony){ ?> id="cameron_plugin"<?php } ?> class="cameron_plugin" style="<?php echo $__Context->addon_info->positionx ?>:0<?php if($__Context->addon_info->positiony){ ?>; top:<?php echo $__Context->addon_info->positiony ?>px<?php } ?>">
	<ul>
		<li id="cameron-lang"><a href="#" class="icon langToggle" title="Select Language"><?php echo $__Context->lang_type ?></a>
			<ul class="selectLang" style="<?php echo $__Context->addon_info->positionx ?>:41px">
				<?php if($__Context->lang_supported&&count($__Context->lang_supported))foreach($__Context->lang_supported as $__Context->key=>$__Context->val){;
if($__Context->key!=$__Context->lang_type){ ?><li><a href="#" onclick="doChangeLangType('<?php echo $__Context->key ?>');return false;"><?php echo $__Context->val ?></a></li><?php }} ?>
			</ul>
		</li>
		<?php if($__Context->addon_info->fb){ ?><li><a class="icon cameron-facebook" href="<?php echo $__Context->addon_info->fb ?>" title="Facebook" target="_blank"></a></li><?php } ?>
		<?php if($__Context->addon_info->tw){ ?><li><a class="icon cameron-twitter" href="<?php echo $__Context->addon_info->tw ?>" title="Twitter" target="_blank"></a></li><?php } ?>
		<?php if($__Context->addon_info->rss){ ?><li><a class="icon cameron-rss" href="<?php echo $__Context->addon_info->rss ?>" title="RSS" target="_blank"></a></li><?php } ?>
		<?php if($__Context->addon_info->uurl){ ?><li>
			<?php if(!$__Context->addon_info->utitle){;
$__Context->addon_info->utitle='CAMERON';
} ?>
			<?php if(!$__Context->addon_info->ubgcolor){;
$__Context->addon_info->ubgcolor='#cc3e3e';
} ?>
			<a href="<?php echo $__Context->addon_info->uurl ?>" class="icon cameron-user" title="<?php echo $__Context->addon_info->utitle ?>" target="_blank" style="background-color:<?php echo $__Context->addon_info->ubgcolor;
if($__Context->addon_info->uicon){ ?>; background-image:url(<?php echo $__Context->addon_info->uicon ?>)<?php } ?>"></a>
		</li><?php } ?>
	</ul>
</div>