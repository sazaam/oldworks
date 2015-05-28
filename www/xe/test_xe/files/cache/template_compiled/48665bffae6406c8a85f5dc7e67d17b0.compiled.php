<?php if(!defined("__XE__"))exit;?><!--#Meta:widgets/language_select/skins/default/js/language_select.js--><?php $__tmp=array('widgets/language_select/skins/default/js/language_select.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php if($__Context->colorset == "black" || $__Context->colorset == "white"){ ?>
    <!--#Meta:widgets/language_select/skins/default/css/widget.css--><?php $__tmp=array('widgets/language_select/skins/default/css/widget.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php } ?>
<div class="widgetContainer<?php if($__Context->colorset=="black"){ ?> black<?php } ?>">
    <div class="widgetLanguage">
        <p><a href="#" class="cafeXeA language_selector">Language:<?php echo $__Context->lang_supported[$__Context->lang_type] ?></a></p>
        <ul class="langList" style="right: 3px;">
            <!-- class="" | class="open" -->
            <?php if($__Context->lang_supported&&count($__Context->lang_supported))foreach($__Context->lang_supported as $__Context->key => $__Context->val){ ?>
            <?php if($__Context->key != $__Context->lang_type){ ?>
            <li><a href="#" onclick="doChangeLangType('<?php echo $__Context->key ?>');return false;"><?php echo $__Context->val ?></a></li>
            <?php } ?>
            <?php } ?>
        </ul>
    </div>
</div>
