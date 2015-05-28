<?php if(!defined("__XE__"))exit;?>﻿
<style type="text/css">
	@import "./layouts/pcaa/css/fonts/font.css";
	@import "./layouts/pcaa/css/plug/default.css";
	@import "./layouts/pcaa/css/plug/base.css";
	@import "./layouts/pcaa/css/pcaa.css";
	@import "./layouts/pcaa/css/mq.css";
</style>
<script type="text/javascript">
	
	function doChangeLangType(a){
		setLangType(a) ;
		location.href = location.href ;
	}
	
</script>
<div class="all">
	
	<div class="abs right0 txtR top0 paddingLg context" style="z-index:3000">
		<div class="lang floatL">
			<strong class="userLang floatL <?php echo $__Context->lang_type ?>">
				<span class="hidden"><?php echo $__Context->lang_supported[$__Context->lang_type] ?></span>
			</strong>
			<ul class="langList">
				<?php if($__Context->lang_supported&&count($__Context->lang_supported))foreach($__Context->lang_supported as $__Context->key=>$__Context->val){;
if($__Context->key != $__Context->lang_type){ ?><li>
					<a class="userLang <?php echo $__Context->key ?>" href="#" onclick="doChangeLangType('<?php echo $__Context->key ?>');location.reload();return false;">
						<span class="hidden"><?php echo $__Context->val ?></span>
					</a>
				</li><?php }} ?>
			</ul>
		</div>
	
	</div>
	
	
	
	<div class="header padding HpaddingLg context">
		<h1 class="logo floatL">
			<a class="dispBlock fullW fullH" href="<?php echo $__Context->request_uri ?>">
				<span class="hidden">
					Site Logo
				</span>		
			</a>
		</h1>
		<form action="<?php echo getUrl() ?>" method="get" class="search dispNone floatR Vmargin"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" />
			<input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
			<input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" />
			<input type="hidden" name="act" value="IS" />
			<input class="input TmarginSm txtR" type="text" name="is_keyword" value="<?php echo $__Context->is_keyword ?>" title="<?php echo $__Context->lang->cmd_search ?>" />
			<input class="submit TmarginSm" type="submit" value="<?php echo $__Context->lang->cmd_search ?>" />
		</form>
	</div>
	
	
	
	<div class="sidenav <?php echo !$__Context->act ? 'noact' : 'act'  ?>">
		<div class="nav paddingLg">
			<?php if($__Context->module_info->mid == 'PCAA'){ ?><div class="home dyncont content padding Rpadding0">
				<div class="body">
					<?php echo $__Context->content ?>
					<div class="curtainall">
						<div class="curtain">
							<!--  -->
						</div>
					</div>
				</div>
			</div><?php } ?>
			<ul class="navitems">
				
				<?php if($__Context->main_menu->list&&count($__Context->main_menu->list))foreach($__Context->main_menu->list as $__Context->key1=>$__Context->val1){ ?><li>
				<?php  if ($__Context->val1['selected']) $__Context->temp = $__Context->val1 ; ?>
					
					<div class="context menulinkall topmenulinkall">
						<a id="<?php echo $__Context->val1['node_srl'] ?>" class="menulink <?php echo $__Context->val1['is_shortcut'] == Y ? 'sectionfold' : 'nosectionfold' ?>" href="<?php echo $__Context->request_uri.$__Context->val1['url'].'/' ?>"<?php if($__Context->val1['open_window']=='Y'){ ?> target="_blank"<?php } ?>><?php echo $__Context->val1['text'] ?></a>
						<?php if($__Context->val1['is_shortcut'] == N){ ?><a class="fold" href="#"><span class="hidden">fold-unfold</span></a><?php } ?>
					</div>
					
					<?php if($__Context->val1['list']){ ?><ul id="<?php echo $__Context->val1['node_srl'] ?>nested" class="nested context <?php echo $__Context->val1['selected'] ? '' : 'dispNone' ?>" rel="<?php echo sizeof($__Context->val1['list']) ?>">
						
						<?php if($__Context->val1['list']&&count($__Context->val1['list']))foreach($__Context->val1['list'] as $__Context->key2=>$__Context->val2){ ?><li>
						<?php  if ($__Context->val2['selected']) $__Context->temp = $__Context->val2 ; ?>
							
							<div class="context menulinkall Hpadding">
								<a id="<?php echo $__Context->val2['node_srl'] ?>" class="nestedchild menulink" rel="<?php echo $__Context->val2['parent_srl'] ?>" href="<?php echo $__Context->request_uri.$__Context->val2['url'].'/' ?>"<?php if($__Context->val2['open_window']=='Y'){ ?> target="_blank"<?php } ?>><?php echo $__Context->val2['text'] ?></a>
								<a class="fold" href="#"><span class="hidden">fold-unfold</span></a>
							</div>
						</li><?php } ?>
					</ul><?php } ?>
					
					<?php if($__Context->val1['list']&&count($__Context->val1['list']))foreach($__Context->val1['list'] as $__Context->key2=>$__Context->val2){;
if($__Context->val1['list']){ ?><div id="<?php echo $__Context->val2['node_srl'] ?>container"></div><?php }} ?>
					<div id="<?php echo $__Context->val1['node_srl'] ?>container"></div>
				</li><?php } ?>
			</ul>
			<?php if($__Context->module_info->mid == $__Context->temp['url']){ ?><div class="dyncont content padding Rpadding0">
				<div class="body">
					<?php echo $__Context->content ?>
					<div class="curtainall">
						<div class="curtain">
							<!--  -->
						</div>
					</div>
				</div>
			</div><?php } ?>
		</div>
		
		
		<div class="footer HpaddingLg xs">
			<span style="color:#777;">How to come to the Office</span>
			<span class="dispBlock"></span>(143-180) 315-12 NeungDong GwangjinGu Seoul </span>
			<span class="dispBlock">Tel) 02.556.6903 Fax) 02.556.6904</span>
			<span class="dispBlock">Copyright(c) 2014, UTAA. All Rights Reserved.</span>
		</div>
		
	
	</div>
	<div class="deepnav paddingLg">
		<!-- 
		<?php if($__Context->main_menu->list&&count($__Context->main_menu->list))foreach($__Context->main_menu->list as $__Context->key1=>$__Context->val1){;
if($__Context->val1['selected']){ ?><h2 class="XLg">
			<a href="<?php echo $__Context->val1['href'] ?>"<?php if($__Context->val1['open_window']=='Y'){ ?> target="_blank"<?php } ?>><?php echo $__Context->val1['link'] ?></a>
		</h2><?php }} ?> 
		-->
		<?php if($__Context->main_menu->list&&count($__Context->main_menu->list))foreach($__Context->main_menu->list as $__Context->key1=>$__Context->val1){;
if($__Context->val1['selected'] && $__Context->val1['list']){ ?><ul class="nested Hpadding">
			<?php if($__Context->val1['list']&&count($__Context->val1['list']))foreach($__Context->val1['list'] as $__Context->key2=>$__Context->val2){ ?><li<?php if($__Context->val2['selected']){ ?> class="active"<?php } ?>>
				<a href="<?php echo $__Context->val2['href'] ?>"<?php if($__Context->val2['open_window']=='Y'){ ?> target="_blank"<?php } ?>><?php echo $__Context->val2['link'] ?></a>
				<?php if($__Context->val2['list']){ ?><ul class="nested Hpadding">
					<?php if($__Context->val2['list']&&count($__Context->val2['list']))foreach($__Context->val2['list'] as $__Context->key3=>$__Context->val3){ ?><li<?php if($__Context->val3['selected']){ ?> class="active"<?php } ?>>
						<a href="<?php echo $__Context->val3['href'] ?>"<?php if($__Context->val3['open_window']=='Y'){ ?> target="_blank"<?php } ?>><?php echo $__Context->val3['link'] ?></a>
					</li><?php } ?>
				</ul><?php } ?>
			</li><?php } ?>
		</ul><?php }} ?>
	</div>
	
	
	<?php if(!$__Context->act){ ?><script type="text/javascript" src="/xe/test_xe/layouts/pcaa/js/strawnode.js?starter=./pcaa_app/" /><?php } ?>
	
	
</div>