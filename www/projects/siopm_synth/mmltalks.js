// MTDSP object
//------------------------------
MTDSP = function() {};
MTDSP.VERSION = '0.2.42';
MTDSP.SWF_VERSION = 'SWF has not loaded.';
MTDSP.mmlPlayerID = 'playerObject';
MTDSP.mmlPlayer = undefined;
MTDSP.mmlPlayerType = 'normal';
MTDSP.loaded = false;
MTDSP.playing = false;
MTDSP.playLimit = 180;
MTDSP.startTime = 0;
MTDSP.mmlid = '';

MTDSP.play = function(_mml) { MTDSP.mmlPlayer._play(_mml, MTDSP.mmlid, MTDSP.playLimit, MTDSP.startTime); }
MTDSP.stop = function() { MTDSP.mmlPlayer._stop(); }

MTDSP.onLoad = function() {}
MTDSP.onNext = function() {}
MTDSP.onStreamStart = function() {}
MTDSP.onPlayPushed = function() { return true; }
MTDSP.onFinishSequence = function() {}
MTDSP.onError = function(errorMessage){ alert(errorMessage); }


// global valiables
//------------------------------
MMLTalks = function() {
}

MMLTalks.prototype = {
    username : "",
    hosturl : ""
}



function initializePlayer($player, playerType) {
    initializeGlobalValiables();
    
    // check flash players major version
    if (getFlashPlayerVersion(0) < 10) {
        MTDSP.onError("The SiOPM module is only available on Flash Player 10.");
        return;
    }
    
    // swf name
    mmlPlayerType = playerType;
    var swfName = MMLTalks.hosturl + 'script/';
    if (playerType == 'mini') swfName += 'mtdspmini.swf';
    else swfName += 'mtdsp.swf';
    swfName += '?version=' + MTDSP.VERSION;//'?' + (new Date()).getTime(); //

    // insert swf object in <div id='player'/>
    var div = $player.get(0);
    if (div) {
        // insert object
        if (navigator.plugins && navigator.mimeTypes && navigator.mimeTypes.length) {
            // ns
            var o = document.createElement('object');
            o.id = MTDSP.mmlPlayerID;
            o.classid = 'clsid:D27CDB6E-AE6D-11cf-96B8-444553540000';
            o.width = $player.width();
            o.height = $player.height();
            o.setAttribute('data', swfName);
            o.setAttribute('type', 'application/x-shockwave-flash');
            var p = document.createElement('param');
            p.setAttribute('name', 'allowScriptAccess');
            p.setAttribute('value', 'always');
            o.appendChild(p);
            div.appendChild(o);
        } else {
            // ie
            var object = '<object id="' + MTDSP.mmlPlayerID + '" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" ';
            object    += 'width="' + $player.width() + '" height="' + $player.height() + '">';
            object    += '<param name="movie" value="' + swfName + '" />';
            object    += '<param name="bgcolor" value="#FFFFFF" />';
            object    += '<param name="allowScriptAccess" value="always" />';
            object    += '</object>';
            div.innerHTML += object;
        }
    }
}


function initializeGlobalValiables() {
    MMLTalks.username = $.cookie('username') || "Anonymous";
    MMLTalks.hosturl  = 'http://' + location.host + '/';
    if (!$.support['style']) { // for ie6
        entryLoadLimit = 2;
        entryPageLength = 6;
    }
}


function MT_message(mes) {
    $("div#message").text(mes);
}


function MT_request(functionName, args, callback) {
    if (!args) args = new Array();
    
    var query = 'action=' + encodeURIComponent(functionName);
    for (var key in args) query += '&' + key + '=' + encodeURIComponent(args[key]);
    
    query += '&time=' + new Date().getTime();
    $.post('http://' + location.host + '/rpc', query, callback, 'text');
}

function redirect(url) {
    document.location.href = url;
}

var scope_discription = [
    "All people can listen to your post. The post appears on public time line.",
    "Only MMLTalks users can listen to your post. The post appears on users time line.",
    "The post is stored and permanent link is created. But it doesnt appear on any time lines."
];
var scope_discription_j = [
    "Public Time Line に現れ，誰でも聞くことができます．",
    "User Time Line に現れ MMLTalks users しか聞くことができません. ",
    "Time Line 上に現れませんが，パーマネントリンクは作成されます．",
];
var scope_type = [
    "public",
    "protected",
    "private",
];





//------------------------------------------------------------------------------------------------------------------------
// page operations
//------------------------------
var currentListType = -1;
var playingIndex = -1;
var $entryCache = {};
var mmlidList = [];
var entryPageLength = 8;
var entryPageIndex = 0;
var entryListLength = 100;
var entryListIndex = 0;
var entryListTag = '';
var entryListAuthor = '';
var entryListPermission = 0;
var entryLoadLimit = 8;
var allListLoaded = false;
var favlist = {};
var $loading = $("<div class='entry' mmlid='-'><div class='entrytitle'><h2>Loading ...</h2></div><div class='author'>by&nbsp;----</div></div>");


function onCommentClick(img) {
    var $toggleDisplay = $(img).parents("div.entry").children("div.toggleDisplay");
    if ($toggleDisplay.css('display') == 'none') {
        $("div.toggleDisplay").slideUp("fast");
        $toggleDisplay.slideDown("fast");
    } else {
        $toggleDisplay.slideUp("fast");
    }
}
function onCommentOver(img)  { $(img).attr("src", MMLTalks.hosturl + "image/comment_ov.gif"); }
function onCommentOut(img)   { $(img).attr("src", MMLTalks.hosturl + "image/comment.gif"); }
function onUpOver(img)  { $(img).attr("src", MMLTalks.hosturl + "image/up_ov.gif"); }
function onUpOut(img)   { $(img).attr("src", MMLTalks.hosturl + "image/up.gif"); }
function onDownOver(img)  { $(img).attr("src", MMLTalks.hosturl + "image/down_ov.gif"); }
function onDownOut(img)   { $(img).attr("src", MMLTalks.hosturl + "image/down.gif"); }
function onShowMMLOver(img)  { $(img).attr("src", MMLTalks.hosturl + "image/showmml_ov.gif"); }
function onShowMMLOut(img)   { $(img).attr("src", MMLTalks.hosturl + "image/showmml.gif"); }
function onHatenaBMOver(img) { $(img).attr("src", MMLTalks.hosturl + "image/hatenabm_ov.gif"); }
function onHatenaBMOut(img)  { $(img).attr("src", MMLTalks.hosturl + "image/hatenabm.gif"); }
function onDeliciousOver(img){ $(img).attr("src", MMLTalks.hosturl + "image/delicious_ov.gif"); }
function onDeliciousOut(img) { $(img).attr("src", MMLTalks.hosturl + "image/delicious.gif"); }
function onEntryTitleOver(h2) { $(h2).addClass("mouseon"); }
function onEntryTitleOut(h2)  { $(h2).removeClass("mouseon"); }
function onTwitterOver(img)  { $(img).attr("src", MMLTalks.hosturl + "image/twit_ov.gif"); }
function onTwitterOut(img)   { $(img).attr("src", MMLTalks.hosturl + "image/twit.gif"); }
function onReplaceOver(img)  { $(img).attr("src", MMLTalks.hosturl + "image/player_over.png"); }
function onReplaceOut(img)   { $(img).attr("src", MMLTalks.hosturl + "image/player_replace.png"); }
function onMMLOver(div) { $(div).addClass("mouseon"); }
function onMMLOut(div)  { $(div).removeClass("mouseon"); }
function onMMLClick(div) { MTDSP.mmlid=""; MTDSP.play($(div).text()); }

function twit(url, text, id) { 
  var content = encodeURIComponent(text + " #WebMML #MMLTalks" + (id||""));
  window.open("http://twitter.com/intent/tweet?&url=" + encodeURIComponent(url) + "&text=" + content);
}

function onClickStar(star) {
    if ($.cookie('sid')) {
        var $star = $(star);
        var $favcount = $star.next();
        if ($star.hasClass('checked')) {
            MT_request('removefavorite', { 'mmlid':$star.attr('mmlid') }, function() {
                if (arguments[0] != -1) {
                    $star.attr("src", MMLTalks.hosturl + "image/star.gif").removeClass('checked');
                    if (arguments[0] == 0) $favcount.text('0');
                    else $favcount.text(arguments[0]);
                    delete favlist[$star.attr('mmlid')];
                }
            });
        } else {
            MT_request('addfavorite', { 'mmlid':$star.attr('mmlid') }, function() {
                if (arguments[0] != -1) {
                    $star.attr("src", MMLTalks.hosturl + "image/star_ov.gif").addClass('checked');
                    if (arguments[0] == 0) $favcount.text('0');
                    else $favcount.text(arguments[0]);
                    tag = {"tags":""};
                    favlist[$star.attr('mmlid')] = tag;
                    var $entry = $star.parents('div.entry');
                    if ($entry) _updateUserTags($entry.children('div.usertags'), tag);
                }
            });
        }
    }
}

function onEntrySelected(header) {
    var $header = $(header);
    var $h2 = $header.children('h2');
    if ($h2.hasClass("selected")) {
        $h2.removeClass("selected");
        _stop();
    } else {
        _playEntry($header.parents('div.entry'));
    }
}

function selectListType(selected, selectedType, tag) {
    var $selected = $(selected);
    $selected.siblings().removeClass('selected');
    $selected.addClass('selected');
    if (tag == undefined) tag = '';
    if (currentListType != selectedType || entryListTag != tag) {
        currentListType = selectedType;
        entryListPermission = (currentListType == 2) ? 1 : currentListType;
        initializeList(tag);
    }
}

function onClickTags(link) {
    initializeList($(link).children('span#tag').text());
}

function initializeList(tag) {
    entryListTag = tag || '';
    mmlidList = [];
    entryListIndex = 0;
    entryPageIndex = 0;
    allListLoaded = false;
    _updateList();
}

function onEditTags(link) {
    var $divtags = $(link).parents('div.usertags');
    var $entry = $divtags.parents('div.entry');
    var $divedit = $entry.children('div.tagedit');
    var mmlid = $entry.attr('mmlid');
    if (mmlid in favlist) {
        $divedit.children('input#tagsinput').val(favlist[mmlid].tags);
        $divedit.show();
    }
}
function onSubmitTags(button) {
    var $tagsinput = $(button).prev();
    var $tagedit = $(button).parent();
    var $entry = $tagedit.parent();
    var $divusertags = $entry.children('div.usertags');
    var mmlid = $entry.attr('mmlid');
    favlist[mmlid] = {"tags":$tagsinput.val()};
    $tagedit.hide();
    $divusertags.text('submit your tags ...');
    MT_request('edittag', { 'mmlid':mmlid, 'tags':favlist[mmlid].tags }, function() {
        $entry.children('div.tags').html(arguments[0]);
        _updateUserTags($divusertags, favlist[mmlid]);
    });
}

function extractMML(comment) {
    if (comment.match(/{{{([\s\S]+?)}}}/)) return RegExp.$1;
    return null;
}

function renderMMLTalks(html) {
    return html.replace(/{{{\s*([\s\S]+?)\s*}}}/g, '<div class="mml" onmouseover="onMMLOver(this);" onmouseout="onMMLOut(this);" onclick="onMMLClick(this);"><pre>$1</pre></div>')
}

function playMMLID(mmlid) {
    MTDSP.mmlid = mmlid;
    if (mmlid in $entryCache) _playEntry($entryCache[mmlid]);
    else {
        MT_message("Loading MML ...");
        _updateCache([mmlid], function() {
            MT_message("Play");
            if (mmlid in $entryCache) _playEntry($entryCache[mmlid]);
        });
    }
}

function addComment(submit_button) {
    var $input = $(submit_button).parents('div#commentinput'),
        $comment = $input.children('input#newcomment_cont'),
        cont = $comment.val();
    if (cont == '') {
        //alert("コメントを入力してください．");
        alert("Please input some comment text.");
    } else
    if (cont.search(/https?:/i) != -1) {
        //alert("コメント欄にURLを入力する事はできません．");
        alert("The comment should not include any URLs.");
    } else {
        MT_message("Posting your comment ...");
        var $entry = $input.parents('div.entry');
        $comment.val('');
        MT_request('addcomment', {
                'mmlid' : $entry.attr('mmlid'), 
                'name'  : $input.children('input#newcomment_name').val(), 
                'title' : '',
                'cont'  : cont,
                'type'  : 1,
                'return_type' : 'entry'
            }, 
            function() { 
                var $comcount = $entry.children('div.control').children('span.comment_count');
                $comcount.text(Number($comcount.text()) + 1);
                $entry.children('div#comments').children('div#commentlist').append($(arguments[0]).fadeIn());
            }
        );
    }
}

function removeComment(link) {
    var $cc = $(link).parents('div.commentcolumn');
    var args = {
        'comid' : $cc.attr('comid'),
        'mmlid' : $cc.parents('div.entry').attr('mmlid')
    };
    MT_message("Deleting your comment ...");
    MT_request('removecomment', args, function() {
        MT_message("Ready");
        $cc.hide();
        var $comcount = $cc.parents('div.entry').children('div.control').children('span.comment_count');
        $comcount.text(Number($comcount.text()) - 1);
    });
}

function getNext() {
    entryPageIndex += entryPageLength;
    $('span#page').text(Math.floor(entryPageIndex/entryPageLength)+1);
    if (entryListIndex <= entryPageIndex) _updateList();
    else _updateMain();
}

function getPrev() {
    entryPageIndex -= entryPageLength;
    $('span#page').text(Math.floor(entryPageIndex/entryPageLength)+1);
    if (entryPageIndex < 0) entryPageIndex = 0;
    _updateMain();
}

function _updateMain(callback) {
    var listNotCached = [],
        displayMax = entryPageIndex + entryPageLength,
        loadingMax = displayMax + entryPageLength,
        $entry, i;
    if (loadingMax > entryListIndex) {
        if (allListLoaded) loadingMax = entryListIndex;
        else {
            _updateList(callback);
            return;
        }
    }
    if (displayMax > entryListIndex) displayMax = entryListIndex;
    var entries = [];
    var $main = $('div#main');
    $main.html('');
    for (i=entryPageIndex; i<displayMax; i++) {
        var mmlid = mmlidList[i];
        if (mmlid in $entryCache) {
            $entry = $entryCache[mmlid];
            $entry.attr('index', i);
            $main.append($entry);
        } else {
            if (listNotCached.length < entryLoadLimit) listNotCached.push(mmlid);
            $main.append($loading.clone());
        }
    }
    for (; i<loadingMax; i++) {
        mmlid = mmlidList[i];
        if (!(mmlid in $entryCache)) {
            if (listNotCached.length < entryLoadLimit) listNotCached.push(mmlid);
        }
    }

    $('div.tagedit').hide();
    if (currentListType == 2) {
        $('div.usertags').show();
        $('div.tags').hide();
    } else {
        $('div.usertags').hide();
        $('div.tags').show();
    }
    
    $('a#prevbutton').show();
    $('a#nextbutton').show();
    if (entryPageIndex == 0) $('a#prevbutton').hide();
    if (allListLoaded && entryListIndex <= (entryPageIndex + entryPageLength)) $('a#nextbutton').hide();

    if (listNotCached.length > 0) _updateCache(listNotCached, _updateMain);
    else if (callback) callback();
}

function _updateList(callback) {
    if (allListLoaded) return;
    args = { offset:entryListIndex, length:entryListLength, permission:entryListPermission };
    if (entryListTag != '') args['tag'] = entryListTag;
    if (entryListAuthor != '') args['author'] = entryListAuthor;
    if (currentListType == 2) args['mylist'] = MMLTalks.username;
    MT_message("Loading entry list ...");
    MT_request('getlist', args, function (mmllist) {
        if (mmllist != '') {
            var recieved = mmllist.split(',');
            Array.prototype.push.apply(mmlidList, recieved);
            entryListIndex += recieved.length;
            allListLoaded = (recieved.length != entryListLength || recieved.length == 0);
            if (entryListTag != '') {
                $('span#selectedTag').html("tag:["+entryListTag+"]&nbsp;<a href='#' onClick='initializeList(); return false;'>clear</a>");
            } else {
                $('span#selectedTag').html("");
            }
            _updateMain(callback);
        }
        MT_message("Ready");
    });
}

function _updateCache(list, callback) {
    MT_request('getmml', { 'mmlids':list.join(',') }, function(res) {
        $(res).filter('div.entry').each(function() {
            var $entry = $(this);
            var mmlid = $entry.attr('mmlid');
            $entryCache[mmlid] = _modifyEntry($entry);
        });
        callback();
    });
}

function _modifyEntry($entry) {
    var $control = $entry.children('div.control');
    if ($.cookie('sid')) {
        var mmlid = $entry.attr('mmlid');
        if (mmlid in favlist) {
            $control.children('img.favorite').attr("src", MMLTalks.hosturl + "image/star_ov.gif").addClass('checked');
            _updateUserTags($entry.children('div.usertags'), favlist[mmlid]);
        } else {
            $control.children('img.favorite').attr("src", MMLTalks.hosturl + "image/star.gif").removeClass('checked');
        }
        var author = $control.children('a.editlink').attr("author");
        if (author != MMLTalks.username || author == "Anonymous") $control.children('a.editlink').hide();
        var $comments = $entry.children('div#comments');
        $comments.children('div#commentlist').children('div.'+MMLTalks.username).each(function () {
            $(this).append(" <a href='#' onClick='removeComment(this); return false'>[delete]</a>");
        });
        $comments.children('div#commentinput').children('input#newcomment_name').val(MMLTalks.username);
    } else {
        var $imgfav = $control.children('img.favorite');
        $imgfav.click(function(){});
        $imgfav.css('cursor', 'default');
        var author = $control.children('a.editlink').attr("author");
        if (author != "Anonymous") $control.children('a.editlink').hide();
    }
    return $entry;
}

function _updateUserTags($div_usertags, usertags) {
    if (!usertags.html) {
        var usertags_string = [];
        var tags = usertags.tags.split(' ');
        for (var i = 0; i<tags.length; i++) {
            if (tags[i] != '') {
                usertags_string.push("<a href='#' onClick='onClickTags(this); return false;'>[<span id='tag'>");
                usertags_string.push(tags[i]);
                usertags_string.push("</span>]</a>");
            }
        }
        usertags_string.push("&nbsp;<a href='#' onClick='onEditTags(this); return false;'>Edit</a>");
        usertags.html = usertags_string.join('');
    }
    $div_usertags.html(usertags.html);
}

function _playEntry($entry) {
    if (MTDSP.mmlid) $entryCache[MTDSP.mmlid].find('h2').removeClass("selected");
    $entry.children('div.entrytitle').children('h2').addClass("selected");
    playingIndex = parseInt($entry.attr('index'));
    MTDSP.mmlid = $entry.attr('mmlid');
    MTDSP.play($entry.children("div.mml").text());
}

function _stop() {
    MTDSP.stop();
}

function _playNext() {
    if (entryPageIndex + entryPageLength <= playingIndex+1) {
        entryPageIndex += entryPageLength;
        if (entryListIndex <= entryPageIndex) _updateList(_playNext);
        else _updateMain(_playNext);
    } else {
        if (playingIndex < mmlidList.length) {
            var mmlid = mmlidList[playingIndex+1];
            if (mmlid in $entryCache) _playEntry($entryCache[mmlid]);
        } else if (playingIndex != -1) {
            playingIndex = -1;
            _playNext();
        }
    }
}

function minimizePlayer() {
    if (MTDSP.mmlPlayer && MTDSP.mmlPlayerType != 'mini') {
        MTDSP.mmlPlayer._displayMode(0);
        $('div#player').height(119);
    }
}

function maximizePlayer() {
    if (MTDSP.mmlPlayer && MTDSP.mmlPlayerType != 'mini') {
        MTDSP.mmlPlayer._displayMode(1);
        $('div#player').height(320);
    }
}




//------------------------------------------------------------------------------------------------------------------------
// internal functions
//------------------------------
// get Flash player version numbers. argument requires sub numbers.
function getFlashPlayerVersion(subs) {
    return (navigator.plugins && navigator.mimeTypes && navigator.mimeTypes.length) ? 
        navigator.plugins["Shockwave Flash"].description.match(/([0-9]+)/)[subs] : 
        (new ActiveXObject("ShockwaveFlash.ShockwaveFlash")).GetVariable("$version").match(/([0-9]+)/)[subs];
}

// callback from siopm.swf
MTDSP._internal_onLoad = function(version) {
    MTDSP.SWF_VERSION = version;
    MTDSP.loaded = true;
    MTDSP.mmlPlayer = document.getElementById(MTDSP.mmlPlayerID);
    MTDSP.mmlPlayer._initialize(MMLTalks.hosturl);
    MTDSP.onLoad();
}
MTDSP._internal_onError = function(message) {
    MTDSP.onError(message);
}
MTDSP._internal_onStreamStart = function() {
    MTDSP.playing = true;
    MTDSP.onStreamStart();
}
MTDSP._internal_onFinishSequence = function() {
    MTDSP.playing = false;
    MTDSP.onFinishSequence();
}
MTDSP._internal_onNext = function(repeat) {
    MTDSP.onNext(repeat);
}
MTDSP._internal_onPlayPushed = function() {
    return MTDSP.onPlayPushed();
}

