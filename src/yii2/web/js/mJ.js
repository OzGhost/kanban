
 // this is my java script file

"use strict";
// base value
/*
var $base = (function()
{
    var url = "http://oz.f/yii2/web/";
    var getUrl = function(){
        return url;
    };
    return {
        url: getUrl
    }
})();
*/

// global function
var intToString2Digit = function(n)
{
    if (n < 10)
        return '0' + n;
    else
        return n;
};
var myAjax = function(type, input, dest, $arm, callback)
{
    $.ajax({
        url: $base.url() + dest,
        method: type,
        data: input,
        beforeSend: function()
        {
            icon.waitOn($arm);
        },
        success: function(msg)
        {
            icon.leaveOn($arm);
            if (msg.c != undefined && msg.c > 0)
            {
                message.putError($errorParse(msg.c));
            } else {
                message.clear();
                callback(msg, $arm);
            }
        },
        error: function()
        {
            icon.leaveOn($arm);
            message.putError('Connection failure!');
        }
    });
}
var $ajax_post = function(input, dest, $arm, callback)
{
    myAjax('POST', input, dest, $arm, callback);
}

var $ajax_get = function(input, dest, $arm, callback)
{
    myAjax('GET', input, dest, $arm, callback);
};

var $errorParse = function(error_code)
{
    switch(error_code)
    {
        case 0: return 'No problem.';
        case 1: return 'Input was missing!';
        case 2: return 'Login information incorrect!';
        case 3: return 'Retype-password not matched!';
        case 4: return 'Username has existed!';
        case 5: return 'Project name has been exist!';
        case 6: return 'User name too long!';
        case 7: return 'Password too long!';
        case 8: return 'Permission denied!';
        case 9: return 'Server interrupted!';
        case 10: return 'Invaild data!';
        case 11: return 'Project name too long!';
        case 12: return 'Client problem! F5 please!';
        case 13: return 'Task name too long!';
        case 14: return 'Cannot forward task has done!';
        case 15: return 'You are not responsible this task!';
        case 21: return 'Username not exists!';
        case 22: return 'Password incorrect!';
        case 23: return 'Task name has existed!';
        case 24: return 'You can only process one task at the time!';
        case 25: return 'Cannot change doing task you not process!';
        case 31: return 'Task name was missing!';
        case 32: return 'Deadline date was missing!';
        case 33: return 'Deadline time was missing!';
        case 34: return 'Invalid date format!';
        case 35: return 'Invalid time format!';
        case 36: return 'Deadline must be some point in future!';
    };
    return 'Unknow problem!';
};

// switch panel, window
var $switcher = (function()
{
    // register panel switcher
    var regSwitcher = function()
    {
        message.clear();
        if (!$('#entry-panel').hasClass('reg'))
        {
            $('#entry-panel').addClass('reg');
            $('#login-form').find('input').val("").blur();
        } else {
            $('#entry-panel').removeClass('reg');
            $('#reg-form').find('input').val("").blur();;
        }
    };
    // switch to next window in main work flow
    var forwardWindow = function()
    {
        if ($('#holdAll').hasClass('entry'))
        {
            // case entry to project
            $('#holdAll').addClass('project-list').removeClass('entry');
            $('#logBy').text($('#uname').val());
            $('#entry-panel').find('input').val("");
            $('#notice-switch').removeProp('checked');
            projectControl.loadList();
        } else if ($('#holdAll').hasClass('project-list')) {
            // case project to task
            $('#holdAll').addClass('task-list').removeClass('project-list');
            $('#task-list-panel').find('.limit-height').empty();
        }
    };
    // switch to previous window in main work flow
    var backwardWindow = function()
    {
        if ($('#holdAll').hasClass('task-list'))
        {
            // case task to project
            $('#holdAll').addClass('project-list').removeClass('task-list');
            projectControl.loadList();
        } else if ($('#holdAll').hasClass('project-list')) {
            // case project to entry
            $('#holdAll').addClass('entry').removeClass('project-list');
            $('.limit-height').empty();
        }
    };
    return {
        reg: regSwitcher,
        forward: forwardWindow,
        backward: backwardWindow
    }
}());

// DOM  generator
var $GDOM = (function()
{
    var active = 'w3-hover-teal w3-hover-border-white';
    var wait = 'w3-light-grey w3-hover-grey w3-border-orange w3-hover-border-green';
    // generating project as html DOM use in project list
    var generaProject = function($obj){
        var rmBtn = '<a href="#rmP"><i class="fa fa-times-circle w3-padding-small w3-hover-text-red w3-large"></i></a>';
        var state = '';
        var own = 'Owner';
        // decide DOM element
        if ($obj.Owner == '0')
        {
            own = 'Joiner';
            rmBtn = '';
        }
        switch($obj.Status)
        {
            case '1': state = active; break;
            case '3':
                state = wait;
                rmBtn = '';
                break;
        }
        // return html DOM
        return '<p class="w3-margin w3-padding w3-border '
            + state
            + ' project-represent" pid="'+$obj.ProjectID+'">\
                    <a href="#loadPj'
            + $obj.ProjectID
            + '" class="w3-hover-text-white">'
            + $obj.ProjectName
            + '</a>\
                    <span class="w3-text-teal w3-right w3-hover-text-deep-orange">'
            + own
            + '</span>\
                    <span class="project-more-option w3-text-white">\
                        <a href="#infoP" ft="open-dialog" tg="#project-detail">\
                        <i class="fa fa-info-circle w3-padding-small w3-hover-text-cyan w3-large"></i>\
                        </a>'
            + rmBtn
            + '</span>\
                </p>'
        ;
    };
    // generating project html DOM display in search dialog
    var generateProjectForSearch = function($p){
        var btnJoin = '<a href="#" ft="pv" class="w3-btn w3-right w3-grey w3-padding-small">Joined</a>';
        if ($p.Own != '0') {
            btnJoin = '<a href="#'+$p.ProjectID+'" ft="reqJoin" class="w3-btn w3-right w3-green w3-padding-small">Join</a>';
        }
        if ($p.rOn == '0'){
            btnJoin = '<a href="#" ft="pv" class="w3-btn w3-right w3-light-grey w3-padding-small">Spending</a>';
        }
        return '<li class="w3-hover-shadow w3-padding-small w3-border w3-margin-tiny">\
                            <a href="#" ft="pv">'+$p.ProjectName+'</a>\
                            &nbsp;<span class="w3-tiny w3-text-grey">Owner:\
                                &nbsp;<a href="#" ft="pv">'+$p.UserName+'</a>\
                            </span>'
                            +btnJoin+
                        '</li>';
    };
    // generating user html DOM display in search dialog
    var generateUserForSearch = function($u)
    {
        return '<li class="w3-row w3-border w3-margin-tiny w3-hover-shadow relative-frame">\
                    <div class="w3-col s9 w3-padding">\
                        <span class="w3-small w3-text-grey">Username:&nbsp;</span>\
                        '+$u.UserName+'\
                    </div>\
                    <a href="#invite'+$u.UserID+'" class="w3-center w3-col s3 w3-light-grey w3-hover-green w3-padding">Intive to</a>\
                </li>';
    };
    // generating request was sent, use on request list
    var generateRequestSent = function($rq)
    {
        var name = $rq.ProjectName;
        var title = 'Request was sent to project: ';
        var forThing = $rq.ReceiverName;
        if ($rq.Type == '2')
        {
            name = $rq.ReceiverName;
            forThing = $rq.ProjectName;
            title = 'Invite was sent to user: ';
        }
        return  '<li class="w3-hover-shadow w3-padding-small w3-border w3-margin-tiny">\
                    <span class="w3-tiny">'+title+'</span>\
                        &nbsp;<a href="#" class="w3-text-dark-grey" ft="pv">'
                            +name+' <span class="w3-text-grey">['+forThing+']</span></a>\
                        <a href="#cancelReq'+$rq.ReceiverID + $rq.ProjectID+'" rcv="'
                            + $rq.ReceiverID
                            + '" pid="'
                            +$rq.ProjectID
                            +'" class="w3-btn w3-right w3-light-grey w3-hover-red w3-padding-small">Cancel</a>\
                </li>';
    };
    // generating request was received, use on request list
    var generateRequestReceived = function($rq)
    {
        var prefix = "Request to join";
        var dasher = "+";
        if ($rq.Type == '2')
        {
            prefix = "Invite to";
            dasher = "-";
        }
        return '<li class="w3-hover-shadow w3-padding-small w3-border w3-margin-tiny" pid="'+$rq.ProjectID+'" sd="'+$rq.SenderID+'">\
                <span class="w3-text-grey">'+prefix+'</span>\
                &nbsp;<a href="#" class="w3-text-dark-grey" ft="pv">'+$rq.ProjectName+'</a>\
                &nbsp;<span class="w3-text-grey">['+$rq.SenderName+']</span>\
                <a href="#reqAccept'+$rq.SenderID+dasher+$rq.ProjectID+
                '" class="w3-btn w3-right w3-light-grey w3-hover-green w3-padding-small">Accept</a>\
                <a href="#reqRefuse'+$rq.SenderID+dasher+$rq.ProjectID+
                '" class="w3-btn w3-right w3-light-grey w3-hover-red w3-padding-small w3-border-right">Refuse</a>\
            </li>'
        ;
    };
    // generating confirm delete request, use on request list
    var generateRequestConfirm = function(e)
    {
        var btn = '<a href="#Agree'+e.ProjectID+'" class="w3-btn w3-right w3-light-grey w3-hover-green w3-padding-small">Agree</a>\
                    <a href="#Disagree'+e.ProjectID+'" class="w3-btn w3-right w3-light-grey w3-hover-red w3-padding-small w3-border-right">Disagree</a>';
        if (e.confirmDelete == '1')
        {
            btn = '<a href="#" class="w3-right w3-btn w3-light-grey w3-padding-small">Voted</a>';
        }
        return '<li class="w3-hover-shadow w3-padding-small w3-border w3-margin-tiny" pid="'+e.ProjectID+'">\
                    <span class="w3-text-grey">Vote for</span>\
                    &nbsp;<a href="#" class="w3-text-dark-grey" ft="pv">'+e.ProjectName+'</a>\
                    &nbsp;<span class="w3-text-grey">['+e.Owner+']</span>'
                    +btn+
                '</li>';
    };
    // generating task
    var generateTask = function(t)
    {
        if (t.Status == '4')
            return;
        var at_alias = '';
        var btn_r = '';
        var btn_l = '';
        switch(t.Status)
        {
            case '1':
                at_alias = 'Creator';
                btn_r = '<a href="#fwT'+t.TaskID+'" class="w3-green">\
                                <i class="fa fa-angle-double-right"></i>';
                btn_l = '<a href="#rmT'+t.TaskID+'" class="w3-red">\
                                <i class="fa fa-times"></i>';
                break;
            case '2':
                at_alias = 'Processor';
                btn_r = '<a href="#fwT'+t.TaskID+'" class="w3-green">\
                                <i class="fa fa-angle-double-right"></i>';
                btn_l = '<a href="#bwT'+t.TaskID+'" class="w3-blue-grey">\
                                <i class="fa fa-reply"></i>';
                break;
            case '3':
                at_alias = 'Checker';
                btn_r = '<a href="#" class="w3-green">\
                                <i class="fa fa-check"></i>';
                btn_l = '';
                break;
        }
        return '<div class="w3-hover-shadow w3-border w3-margin-tiny relative-frame obj-task" tkind="'+t.Status+'" tid="'+t.TaskID+'">\
                    <a href="#" ft="open-more">'+t.TaskName+'</a>\
                    <p class="w3-small w3-text-grey w3-margin-0"><span class="w3-tiny">'
                        +at_alias+'&nbsp;</span><span>'+t.AffecterName+'</span></p>\
                    <div class="more-info">\
                        <div class="info w3-small">'
                        +t.Desc_+'\
                        </div>\
                    </div>\
                    <div class="btn-control w3-center">\
                        <div>'
                            +btn_r+'\
                            </a>'
                            +btn_l+'\
                            </a>\
                        </div>\
                    </div>\
                </div>';
    };
    // generating project for choosing to invite
    var generateProjectEselect = function($e)
    {
        return '<div class="w3-row w3-margin-small w3-border w3-hover-shadow w3-small">\
                    <p class="w3-left-align w3-col s9 w3-padding w3-margin-0">\
                        <span class="w3-text-grey w3-small">Project:&nbsp;</span>\
                        '+$e.ProjectName+'\
                    </p>\
                    <a href="#eselect'+$e.ProjectID+'" class="w3-col s3 w3-hover-green w3-padding w3-light-grey">Invite</a>\
                </div>';
    };
    // generate general infomation for project-detail dialog
    var generateGeneralInfomation = function($gi, n)
    {
        var pc = ($gi.Total == 0) ? 0 : Math.round($gi.Done/$gi.Total*100);
        var state = 'Active';
        if ($gi.Status == 2)
            state = 'Old';
        if ($gi.Status == 3)
            state = 'Wait for delete';
        return '\
            <tr>\
                <td style="width: 150px">Project name:</td>\
                <td class="w3-row">\
                    <form action="" method="post">\
                        <div class="w3-col m8">\
                            <input class="w3-input" type="text" value="'+$gi.ProjectName+'" required/>\
                        </div>\
                        <button type="submit" class="w3-col m4 w3-btn-block w3-light-grey">Rename</button>\
                    </form>\
                </td>\
            </tr>\
            <tr>\
                <td>Owner:</td>\
                <td>'+$gi.Owner+'</td>\
            </tr>\
            <tr>\
                <td>Create date:</td>\
                <td>'+$gi.CreateDate.substring(8, 10)+'/'
                        +$gi.CreateDate.substring(5, 7)+'/'
                        +$gi.CreateDate.substring(0, 4)+'</td>\
            </tr>\
            <tr>\
                <td>End date:</td>\
                <td>'+$gi.EndDate+'</td>\
            </tr>\
            <tr>\
                <td>Status:</td>\
                <td>'+state+'</td>\
            </tr>\
            <tr>\
                <td>Member(s):</td>\
                <td>'+n+'</td>\
            </tr>\
            <tr>\
                <td>Task(s):</td>\
                <td>'+$gi.Total+'</td>\
            </tr>\
            <tr>\
                <td>Process:</td>\
                <td>'+pc+'%</td>\
            </tr>\
            <tr>\
                <td colspan="2"><button type="button" ft="logview" class="w3-btn-block w3-margin-top w3-light-grey">Logs view...</button></td>\
            </tr>';
    };
    // generate task name for project detail view
    var generateTaskNameDetail = function($t)
    {
        var color = '';
        switch($t.Status)
        {
            case '1':
                if (0 > (Date.parse($t.DeadLine) - Date.parse((new Date()).toString())))
                    color = 'grey';
                else
                    color = 'khaki';
                break;
            case '2':
                if (0 > (Date.parse($t.DeadLine) - Date.parse((new Date()).toString())))
                    color = 'red';
                else
                    color = 'cyan';
                break;
            case '3':
                if (0 > (Date.parse($t.DeadLine) - Date.parse($t.CompleteDate)))
                    color = 'purple';
                else
                    color = 'green';
                break;
        }
        return '<div class="w3-margin-left w3-border-bottom w3-padding-24 w3-text-'+color+'">'+$t.TaskName+'</div>';
    };
    // generate task line for project detail view
    var generateTaskLine = function($t, offset, wipe, init, esti)
    {
        var color = '';
        var dateval = '';
        switch($t.Status)
        {
            case '1':
                if (0 > (Date.parse($t.DeadLine) - Date.parse((new Date()).toString())))
                    color = 'grey';
                else
                    color = 'khaki';
                dateval = 'Pending...';
                break;
            case '2':
                if (0 > (Date.parse($t.DeadLine) - Date.parse((new Date()).toString())))
                    color = 'red';
                else
                    color = 'cyan';
                dateval = $t.StartDate;
                break;
            case '3':
                if (0 > (Date.parse($t.DeadLine) - Date.parse($t.CompleteDate)))
                    color = 'purple';
                else
                    color = 'green';
                dateval = $t.CompleteDate;
                break;
        }
        return '\
                <div class="flex-view w3-padding-24">\
                    <div class="relative-frame real-time w3-'+color+'" style="margin-left:'+offset+'%; width:'+wipe+'%;">\
                        <span class="realtime-label">'+dateval+'</span>\
                    </div>\
                    <div class="relative-frame estimate-time w3-orange" style="margin-left:'+init+'%; width:'+esti+'%;">\
                        <span class="estimate-label">'+$t.DeadLine+'</span>\
                    </div>\
                </div>';
    };
    // generate log line
    var generateLogLine = function($l)
    {
        var action = "Update from ";
        switch($l.Type)
        {
            case '1':
                action = 'Created by';
                break;
            case '2':
                switch($l.SubType)
                {
                    case '12':
                        action += '"Todo" to "Doing" by';
                        break;
                    case '23':
                        action += '"Doing" to "Done" by';
                        break;
                };
                break;
            case '3':
                action = 'Deleted by';
                break;
        };
        return '<p>'+$l.ModifyDate+' |&nbsp;&nbsp;&nbsp;&nbsp;Task <i>"'+$l.TaskName+'"</i> was '+action+' ['+$l.UserName+']</p>';
    };
    return {
        activeState: active,
        waitState: wait,
        genP: generaProject,
        genP4search: generateProjectForSearch,
        genU4search: generateUserForSearch,
        genReqSent: generateRequestSent,
        genReqReceived: generateRequestReceived,
        genReqConfirm: generateRequestConfirm,
        genTask: generateTask,
        genEselect: generateProjectEselect,
        genGenInfo: generateGeneralInfomation,
        genTaskNameDetail: generateTaskNameDetail,
        genTaskLine: generateTaskLine,
        genLogLine: generateLogLine
    }
})();

// message manager
var message = (function()
{
    // timeoutID holder
    var closer = null;
    var iconError = '<i class="fa fa-exclamation-triangle w3-xlarge"></i> ';
    var iconSuccess = '<i class="fa fa-check w3-xlarge"></i> ';
    var iconMessage = '<i class="fa fa-rss w3-xlarge"></i> ';
    var closeBtn = '<span class="w3-closebtn w3-small w3-padding-tiny" onclick="this.parentElement.style.display='
        +"'none'"
        +'">&times;</span>';
    // popUp something on window
    var putAnother = function($msg, color)
    {
        window.clearTimeout(message.closer);
        var icon = '';
        switch(color)
        {
            case 'red':
                icon = iconError;
                break;
            case 'green':
                icon = iconSuccess;
                break;
            case 'blue':
                icon = iconMessage;
                break;
        };
        color = 'w3-' + color;
        $("body").find('#Msg').remove();
        $("body").append('<div class="w3-padding w3-center '
            + color
            + '" id="Msg">'
            + icon
            + $msg
            + closeBtn
            + '</div>');
        message.closer = window.setTimeout(function(){
            message.clear();
        }, 5000);
    };
    var putError = function($msg)
    {
        putAnother($msg, 'red');
    };
    var putSuccess = function($msg)
    {
        putAnother($msg, 'green');
    };
    var putMessage = function($msg)
    {
        putAnother($msg, 'blue');
    };
    var clear = function()
    {
        $("body").find('#Msg').remove();
    };
    return {
        closer: closer,
        putError: putError,
        putSuccess: putSuccess,
        putMessage: putMessage,
        clear: clear
    };
})();

// icon manager
var icon = (function()
{
    // turn on loading icon
    var waitOn = function($obj)
    {
        $obj.find('i.wait-for-long').remove();
        if ($obj.is('form')){
            $obj.find('button[type="submit"]').prepend('<i class="wait-for-long"></i>');
        } else {
            $obj.prepend('<i class="wait-for-long"></i>');
        }
    };
    // turn loading icon off
    var leaveOn = function($obj)
    {
        $obj.find('i.wait-for-long').remove();
    }
    return {
        waitOn: waitOn,
        leaveOn: leaveOn
    }
})();

var dialog = (function()
{
    // turn up dialog_target
    var turnUp = function(dialog_target)
    {
        $(dialog_target).addClass('show-up');
        $('.over-rem').removeClass('w3-hide');
    };
    // dimiss dialog
    var dimiss = function()
    {
        $('.show-up').removeClass('show-up');
        $('.higher').removeClass('higher');
        $('.over-rem').addClass('w3-hide');
        $(document).off('click', '[href^="#eselect"]');
    };
    // turn up confirm dialog
    var confirm = function($arm, callback)
    {
        dialog.turnUp('.confirm-dialog');
        $(document).on('click', '[ft="dimiss"][name="confirm-button"]', {arm: $arm, cb: callback}, function(e){
            e.preventDefault();
            $(document).off('click', '[ft="dimiss"][name="confirm-button"]');
            dialog.dimiss();
            var val = $(this).attr('href');
            e.data.cb(val, e.data.arm);
        });
    };
    // turn up Possible Invite Project List choice
    var PIPL = function($arm)
    {
        var $dom = '<div class="eselect-wrap">\
                        <div class="eselect-project-4i w3-medium w3-center w3-padding-tiny">\
                            <button type="button" ft="dimiss-parent-only"\
                                class="w3-btn w3-padding-small w3-card-4 w3-red my-dimiss w3-small">&times;</button>\
                            <div class="w3-teal w3-margin-small w3-padding"><b>Choosing project to invite</b></div>\
                        </div>\
                    </div>';
        $('.eselect-wrap').remove();
        $(document).off('click', '[href^="#eselect"]');
        $arm.parent().append($dom);
    };
    // clear project-detail dialog
    var clearProjectDetail = function()
    {
        $("#project-detail").find("table").empty();
        $("#project-detail").find("ol").empty();
        $("#project-detail").find("#tName, #tChart").empty();
    };
    return {
        turnUp: turnUp,
        dimiss: dimiss,
        confirm: confirm,
        PIPL: PIPL,
        clearPD: clearProjectDetail
    }
})();

// searching manager
var searcher = (function()
{
    var id = '#search-form';
    var form = $(id);
    // put result
    var putProjectResultList = function(data)
    {
        form.parent().parent().append($GDOM.genP4search(data));
    };
    var putUserResultList = function(data)
    {
        form.parent().parent().append($GDOM.genU4search(data));
    };
    // clear result set
    var clear  = function()
    {
        var $tg = form.parent().next();
        while ($tg.is('li'))
        {
            $tg.remove();
            $tg = form.parent().next();
        }
        form.find('input').val('').blur();
    };
    // init search tran
    var lookUp = function(flag, something)
    {
        clear();
        if (something.length < 1)
        {
            message.putMessage('Typing something please!');
            return;
        }
        var leek = 0;
        if (flag)
            leek = 1;
        $ajax_get({flag: leek, words: something}, '?r=search', form, function(msg, $arm)
        {
            if (msg.rs.length < 1)
            {
                message.putMessage('We found nothing!');
            } else {
                if (msg.c == -1)
                {
                    msg.rs.forEach(function(e){
                        searcher.putPRL(e);
                    });
                } else
                    if (msg.c == -2)
                    {
                        msg.rs.forEach(function(e)
                        {
                            searcher.putURL(e);
                        });
                    }
            }
        });
    };
    return {
        id: id,
        clear: clear,
        putPRL: putProjectResultList,
        putURL: putUserResultList,
        lookUp: lookUp
    };
})();

// access manager
var AccessControl = (function()
{
    var login = function(input, $arm)
    {
        $ajax_post(input, '?r=access%2Flogin', $arm, function(msg, $obj){
            $switcher.forward();
        });
    };
    var logout = function(input, $arm)
    {
        $ajax_get(input, '?r=access%2Flogout', $arm, function(msg, $obj){
            $switcher.backward();
        });
    };
    var reg = function(input, $arm)
    {
        $ajax_post(input, '?r=access%2Freg', $arm, function(msg, $obj){
            message.putSuccess('Your account was created.');
            setTimeout(function(){
                $switcher.reg();
            }, 2500);
        });
    };
    return {
        login: login,
        logout: logout,
        reg: reg
    }
})();

// project interaction control
var projectControl = (function()
{
    // clear project list
    var clear = function()
    {
        $("#project-list-panel").find('.limit-height').empty();
    };
    // create new project
    var add = function(pnameIn, $arm)
    {
        $ajax_get({ pname: pnameIn }, '?r=project%2Fadd', $arm, function(msg, $arm){
            dialog.dimiss();
            var $p = {
                ProjectID: msg.pid,
                ProjectName: pnameIn,
                Status: '1',
                Owner: '1'
            };
            $('#project-list-panel').find('.limit-height').append($GDOM.genP($p));
        });
    };
    // load project list that user involked
    var loadList = function()
    {
        clear();
        $ajax_get(null, '?r=project%2Floadlist', $('#project-list-panel').find('h2 p'), function(msg, $arm){
            msg.forEach(function(e){
                $('#project-list-panel').find('.limit-height').append($GDOM.genP(e));
            });
        });
    };
    // load project detail
    var loadDetail = function($arm)
    {
        var gpid = $arm.attr('pid');
        $ajax_get({pid: gpid}, '?r=project%2Floaddetail', $arm, function(msg, $arm)
        {
            $('#project-detail').find('table').attr('pid', msg.gi.ProjectID);
            $('#project-detail').find('table').append($GDOM.genGenInfo(msg.gi, msg.ml.length));
            msg.ml.forEach(function(e)
            {
                $('#project-detail').find('ol').append('<li>'+e.UserName+'</li>');
            });
            var baseLength = Date.parse(msg.bd.rightBorder) - Date.parse(msg.bd.leftBorder);
            msg.td.forEach(function(e)
            {
                var offset = 0;
                var wipe = 0;
                var init = 0;
                var esti = 0;
                var x = 0;
                var y = 0;
                var z = 0;

                // calculate init time
                x = Date.parse(e.CreateDate) - Date.parse(msg.bd.leftBorder);
                init = x*100/baseLength;
                // calculate estimate time
                z = Date.parse(e.DeadLine) - Date.parse(e.CreateDate);
                esti = z*100/baseLength;

                if (e.Status == '1')
                {
                    offset = init;

                    y = Date.parse((new Date()).toString()) - Date.parse(e.CreateDate);
                    wipe = y*100/baseLength;

                } else
                    if (e.Status == '2' || e.Status == '3')
                {
                    x = Date.parse(e.StartDate) - Date.parse(msg.bd.leftBorder);
                    offset = x*100/baseLength;

                    if (e.Status == '2')
                    {
                        y = Date.parse((new Date()).toString()) - Date.parse(e.StartDate);
                        wipe = y*100/baseLength;
                    } else {
                        y = Date.parse(e.CompleteDate) - Date.parse(e.StartDate);
                        wipe = y*100/baseLength;
                    }
                }

                $('#project-detail').find('#tName').append($GDOM.genTaskNameDetail(e));

                $('#project-detail').find('#tChart').append($GDOM.genTaskLine(e, offset, wipe, init, esti));
            });
        });
    };
    // request to delete project
    var requestDelete = function($arm)
    {
        // open confirm dialog
        dialog.confirm($arm, function(choice, $arm){
            // get choice
            if (choice != '#Y')
            return;
            // call confirm method with choiced value
            var id = $arm.attr('pid');
            $ajax_get({pid: id}, '?r=project%2Freqdelete', $arm, function(msg, $arm)
            {
                if (msg.c == -1)
                {
                    $arm.remove();
                    message.putSuccess('Project has deleted.');
                } else
                    if (msg.c == 0)
                    {
                        $arm.removeClass($GDOM.activeState).addClass($GDOM.waitState);
                        message.putSuccess('Request for delete project was sent.');
                    }
            });
        });
    };
    // confirm (Y/N) to delete project
    var confirmDelete = function(pidIn, choice, $arm)
    {
        var input = '';
        if (choice === 'Y')
        {
            input = '1';
        } else if (choice === 'N')
        {
            input = '0';
        } else
        { return; }
        $ajax_get({pid: pidIn, theChoice: input}, '?r=project%2Fconfirmdelete', $arm, function(msg, $arm){
            if (msg.ch == 0)
            {
                message.putSuccess('Confirm done.');
                $arm.removeClass($GDOM.activeState).addClass($GDOM.waitState);
                $arm.find('[href="#rmP"]').remove();
            }
            if (msg.ch == 1)
            {
                message.putSuccess('Request delete was denied.');
            }
            if (msg.ch == 2)
            {
                message.putSuccess('Project was deleted.');
                $arm.remove();
            }
        });
    };
    // register project for next time
    var regist = function(pidIn, $arm)
    {
        $ajax_get({pid: pidIn}, '?r=project%2Fregist', $arm, function(msg, $arm)
        {
            $switcher.forward();
            var pjName = $arm.find('a:first').text();
            $('#curPj').text(pjName);;
            taskControl.loadList();
        });
    };
    // unregister project
    var unregist = function($arm)
    {
        $ajax_get(null, '?r=project%2Funregist', $arm, function(msg, $arm)
        {
            $switcher.backward();
        });
    };
    // get possible invite project list
    var getPossibleInviteProjectList = function(uid, $arm)
    {
        $ajax_get({rcv: uid}, '?r=project%2Fgetpipl', $arm, function(msg, $arm)
        {
            dialog.PIPL($arm);
            if (msg.l.length < 1)
            {
                message.putMessage('No project possible invite');
            } else {
                msg.l.forEach(function(e)
                {
                    $('.eselect-project-4i').append($GDOM.genEselect(e));
                });
                // turn on handling
                $(document).on('click', '[href^="#eselect"]', {f: msg.f}, function(e)
                {
                    e.preventDefault();
                    // $(document).off('click', '[href^="#eselect"]');
                    var id = $(this).attr('href');
                    id = id.substring(8, id.length);
                    projectControl.eselect({uid: e.data.f, pid: id}, $(this));
                });
            }
        });
    };
    // invite asyc
    var invite = function(input, $arm)
    {
        $ajax_get(input, '?r=project%2Finvite', $arm, function(msg, $arm)
        {
            $arm.parent().remove();
        });
    };
    // rename project
    var rename = function(input, arm)
    {
        $ajax_get(input, '?r=project%2Frename', arm, function(msg, arm)
        {
            message.putSuccess('Project has been renamed.');
            projectControl.loadList();
        });
    };
    // log view
    var logView = function(id, arm)
    {
        $ajax_get({pid: id}, '?r=project%2Flogview', arm, function(msg, arm)
        {
            if (msg.length < 1)
            {
                message.putMessage('Empty log :|');
                return;
            }
            $('#log .log-content').empty();
            $('#log').addClass('show-up');
            msg.forEach(function(e)
            {
                $('#log .log-content').append($GDOM.genLogLine(e));
            });
        });
    };
    return {
        clear: clear,
        add: add,
        loadList: loadList,
        reqDelete: requestDelete,
        cfDelete: confirmDelete,
        regist: regist,
        unregist: unregist,
        loadDetail: loadDetail,
        getPIPL: getPossibleInviteProjectList,
        eselect: invite,
        rename: rename,
        logView: logView
    }
})();

// task interaction control
var taskControl = (function()
{
    // add a new task
    var add = function(input, $arm)
    {
        $ajax_get(input, '/?r=task%2Fadd', $arm, function(msg, $arm)
        {
            $arm.find('input, textarea').val('').blur();
            dialog.dimiss();
            $('#todoTask').append($GDOM.genTask(msg.t));
        });
    };
    // clear task list panel
    var clear = function()
    {
        $('#task-list-panel').find('.limit-height').empty();
    };
    // load list of task for current project
    var loadList = function()
    {
        clear();
        $ajax_get(null, '?r=task%2Floadlist', $("#task-list-panel h2"), function(msg, $arm)
        {
            if (msg.length < 1)
            {
                message.putMessage('No task!');
            } else {
                msg.forEach(function(e)
                {
                    var destination = null;
                    switch(e.Status)
                    {
                        case '1': destination = $('#todoTask'); break;
                        case '2': destination = $('#doingTask'); break;
                        case '3': destination = $('#doneTask'); break;
                    }
                    if (e.Status !== '4')
                    {
                        destination.append($GDOM.genTask(e));
                    }
                });
            }
        });
    };
    // delete task from current project
    var deleteTask = function(tidIn, $arm)
    {
        $ajax_get({tid: tidIn}, '?r=task%2Fdelete', $arm, function(msg, $arm)
        {
            $arm.parent().parent().parent().remove();
            message.putSuccess('Task has been deleted.');
        });
    };
    // forward task state
    var updateState = function(input, $arm)
    {
        $ajax_get(input, '?r=task%2Fupdatestate', $arm, function(msg, $arm)
        {
            var destination = '';
            var alias = '&nbsp;';
            var tmp = '';
            var $holder = $arm.parent().parent().parent();
            switch(msg.s)
            {
                case 1:
                    destination = '#todoTask';
                    $holder.find('[href^="#bwT"]').children('i').removeClass('fa-reply').addClass('fa-times');
                    $holder.find('[href^="#bwT"]').removeClass('w3-blue-grey').addClass('w3-red');
                    tmp = $holder.find('[href^="#bwT"]').attr('href');
                    $holder.find('[href^="#bwT"]').attr('href', '#rmT'+tmp.substring(4, tmp.length));
                    alias = 'Creator' + alias;
                    break;
                case 2:
                    destination = '#doingTask';
                    $holder.find('[href^="#rmT"]').children('i').addClass('fa-reply').removeClass('fa-times');
                    $holder.find('[href^="#rmT"]').addClass('w3-blue-grey').removeClass('w3-red');
                    tmp = $holder.find('[href^="#rmT"]').attr('href');
                    $holder.find('[href^="#rmT"]').attr('href', '#bwT'+tmp.substring(4, tmp.length));
                    alias = 'Processor' + alias;
                    break;
                case 3:
                    destination = '#doneTask';
                    $holder.find('[href^="#rmT"], [href^="#bwT"]').remove();
                    $holder.find('[href^="#fwT"]').children('i').removeClass('fa-angle-double-right').addClass('fa-check');
                    $holder.find('[href^="#fwT"]').attr('href', '#');
                    alias = 'Checker' + alias;
                    break;
            }
            $holder.attr('tkind', msg.s);
            $holder.children('p:first').children('span:first').html(alias);
            $holder.children('p:first').children('span:last').text($('#logBy').text());
            $holder.prependTo(destination);
        });
    };
    return {
        add: add,
        loadList: loadList,
        deleteTask: deleteTask,
        updateState: updateState
    }
})();

var requestControl = (function()
{
    // request to join project
    var requestToJoin = function(id, $arm)
    {
        if (!id || id.length < 1)
            message.putError($errorParse(10));
        $ajax_get({pid: id}, '?r=request%2Freqjoin', $arm, function(msg, $arm)
        {
            message.putSuccess('Request was sent.');
            $arm.attr('href', '#').attr('ft', 'pv').text('Spending');
            $arm.removeClass('w3-green').addClass('w3-light-grey');
        });
    };
    // list request was sent
    var listRequestWasSent = function()
    {
        $ajax_get(null, '?r=request%2Flistreqsent', $('#reqSentList').find('li:first'), function(msg, $arm)
        {
            $('#reqSentList').children('li').not(':first').remove();
            if (msg.length < 1)
            {
                message.putMessage('No request was sent.');
            } else {
                msg.forEach(function(e)
                {
                    $('#reqSentList').append($GDOM.genReqSent(e));
                });
            }
        });
    };
    // cancel request have been sent or received
    var cancelRequest = function(input, $arm)
    {
        $ajax_get(input, '?r=request%2Fcancelreq', $arm, function(msg, $arm)
        {
            $arm.parent().remove();
            message.putSuccess('Request have been removed.');
        });
    };
    // list request was received
    var listRequestWasReceived = function()
    {
        $ajax_get(null, '?r=request%2Flistreqreceived', $('#reqReceivedList').find('li:first'), function(msg, $arm)
        {
            $('#reqReceivedList').children('li').not(':first').remove();
            if (msg.length < 1)
            {
                message.putMessage('No request was received.');
            } else {
                msg.forEach(function(e)
                {
                    $('#reqReceivedList').append($GDOM.genReqReceived(e));
                });
            }
        });
    };
    var acceptRequest = function(input, $arm)
    {
        $ajax_get(input, '?r=request%2Facceptreq', $arm, function(msg, $arm)
        {
            $arm.parent().remove();
            if (msg.t === 2){
                projectControl.loadList();
            }
            message.putSuccess('Accept request done.');
        });
    }
    // list request confirm at the moment
    var listConfirmRequest = function()
    {
        $ajax_get(null, '?r=request%2Flistreqconfirm', $('#reqConfirm li:first'), function(msg, $arm)
        {
            $('#reqConfirm').children('li').not(':first').remove();
            if (msg.length < 1)
            {
                message.putMessage('No project wait for delete.');
            } else {
                msg.forEach(function(e)
                {
                    $('#reqConfirm').append($GDOM.genReqConfirm(e));
                });
            }
        });
    };
    // confirm delete request
    var confirmDelete = function(input, $arm)
    {
        $ajax_get(input, '?r=request%2Fconfirmdelete', $arm, function(msg, $arm)
        {
            if (msg.ch == '0')
            {
                var parent = $arm.parent();
                parent.children('a:last').remove();
                parent.children('a:last').remove();
                parent.append('<a href="#" class="w3-right w3-btn w3-light-grey w3-padding-small">Voted</a>');
            } else
                if (msg.ch == '1' || msg.ch == '2')
            {
                $arm.parent().remove();
                var ms = 'Request has been denied.';
                if (msg.ch == '2')
                    ms = 'Project has been deleted.';
                message.putSuccess(ms);
                setTimeout(function()
                {
                    projectControl.loadList();
                }, 3000)
            }
        });
    };
    return {
        reqJoin: requestToJoin,
        listReqSent: listRequestWasSent,
        cancelReq: cancelRequest,
        listReqReceived: listRequestWasReceived,
        listReqConfirm: listConfirmRequest,
        acceptReq: acceptRequest,
        cfDelete: confirmDelete
    }
})();

// style helper
    // prevent click action
$(document).on('click', 'a', function(e)
{
    e.preventDefault();
});
    // open reg panel
$(document).on('click', '[ft="open-reg"]', function()
{
    $switcher.reg();
});
    // prevent click for a element no feature
$(document).on('click', '[ft="pv"]', function(e)
{
    e.preventDefault();
});
    // open dialog
$(document).on('click', '[ft="open-dialog"]', function(){
    var tg = $(this).attr('tg');
    $(tg).toggleClass('show-up');
    $('.over-rem').toggleClass("w3-hide");
    if (tg == '#add-task-dialog'){
        var now = new Date();
        var today = now.getFullYear() + '-' + intToString2Digit(now.getMonth() + 1) + '-' + intToString2Digit(now.getDate());
        var timing = intToString2Digit(now.getHours()) + ':' + intToString2Digit(now.getMinutes());
        $(tg).find('#tdate').val(today);
        $(tg).find('#ttime').val(timing);
    }
});
    // open task description
$(document).on('click', '[ft="open-more"]', function(e){
    e.preventDefault();
    var $father = $(this).parent();
    var $info = $father.find(".info");
    if (!$father.hasClass("more")){
        $info.css("margin-top", "-" + $info.outerHeight() + "px");
    } else {
        $info.css("margin-top", "0px");
    }
    $father.toggleClass('more');
    if (!$father.hasClass("more")){
        $info.css("margin-top", "-" + $info.outerHeight() + "px");
    } else {
        $info.css("margin-top", "0px");
    }
});
    // dimiss dialog
$(document).on('click', '[ft="dimiss"]', function(e){
    if ($(this).is('a')){
        e.preventDefault();
    }
    dialog.dimiss();
});
    // open menu dialog
$(document).on('click', '.menu-item > li > a', function(e){
    e.preventDefault();
    $(this).parent().toggleClass('higher');
    $('.over-rem').toggleClass('w3-hide');
    $(this).next().toggleClass('show-up');
});
    // clear search result
$(document).on('click', '[href="#search"]', function(e)
{
    searcher.clear();
    $('#searchId').focus();
})

// Access control
    // login async
$(document).on('submit', '#login-form', function(e){
    e.preventDefault();
    var unameVal = $(this).find('#uname').val();
    var upassVal = $(this).find('#upass').val();
    if (!unameVal || !upassVal)
    {
        message.putError($errorParse(1));
        return;
    }
    if (unameVal.length > 32)
    {
        message.putError($errorParse(6));
        return;
    }
    if (upassVal.length > 64)
    {
        message.putError($errorParse(7));
        return;
    }
    // register throught AccessControl (Access Control async)
    AccessControl.login({ uname: unameVal, upass: upassVal }, $(this));
});

    // register async
$(document).on('submit', '#reg-form', function(e){
    e.preventDefault();
    var unameVal = $(this).find('#reguname').val();
    var upassVal = $(this).find('#regupass').val();
    var repassVal = $(this).find('#regrepass').val();
    if (!unameVal || !upassVal || !repassVal)
    {
        icon.leaveOn($(this).find('button[type="submit"]'));
        message.putError($errorParse(1));
        return;
    }
    // checking correct password
    if (upassVal !== repassVal)
    {
        icon.leaveOn($(this).find('button[type="submit"]'));
        message.putError($errorParse(3));
        return;
    }
    if (unameVal.length > 32)
    {
        message.putError($errorParse(6));
        return;
    }
    if (upassVal.length > 64)
    {
        message.putError($errorParse(7));
        return;
    }
    // register throught AccessControl (Access Control async)
    AccessControl.reg({ uname: unameVal,
                        upass: upassVal,
                        repass: repassVal }, $(this));
});

    // logout
$(document).on('click', '[href="#out"]', function(e){
    e.preventDefault();
    AccessControl.logout({confirm: 'Yes'}, $(this));
});

// Project manage
    // create new project async
$(document).on('submit', '#add-project-form', function(e){
    e.preventDefault();
    var pname = $(this).find('#pname').val();
    if (!pname)
    {
        message.putError($errorParse(1));
        return;
    }
    if (pname.length > 32)
    {
        message.putError($errorParse(11));
        return;
    }
    projectControl.add(pname, $(this));
});
    // delete project
$(document).on('click', '[href="#rmP"]', function(e){
    e.preventDefault();
    var $arm = $(this).parent().parent();
    projectControl.reqDelete($arm);
});
    // get project detail
$(document).on('click', '[href="#infoP"]', function(e)
{
    e.preventDefault();
    dialog.clearPD();
    var $arm = $(this).parent().parent();
    projectControl.loadDetail($arm);
});

    // request to join project
$(document).on('click', '[ft="reqJoin"]', function(e)
{
    e.preventDefault();
    var id = $(this).attr('href');
    id = id.substring(1, id.length);
    requestControl.reqJoin(id, $(this));
});

    // list request was sent
$(document).on('click', '[href="#reqSent"]', function(e)
{
    e.preventDefault();
    if ($(this).parent().hasClass('higher'))
    {
        requestControl.listReqSent();
    }
});
    // cancel request
$(document).on('click', '[href^="#cancelReq"]', function(e)
{
    e.preventDefault();
    var pidDom = $(this).attr('pid');
    var rcvDom = $(this).attr('rcv');
    requestControl.cancelReq({t: 1, rcv: rcvDom, pid: pidDom}, $(this));
});

    // list request was received
$(document).on('click', '[href="#reqReceived"]', function(e)
{
    e.preventDefault();
    if ($(this).parent().hasClass('higher'))
    {
        requestControl.listReqReceived();
    }
});

    // refuse or accept request
$(document).on('click', '[href^="#reqRefuse"], [href^="#reqAccept"]', function(e)
{
    e.preventDefault();
    var sdIn = $(this).parent().attr('sd');
    var pidIn = $(this).parent().attr('pid');
    var dest_ = $(this).attr('href');
    dest_ = dest_.substring(1, 5);
    if (dest_ === 'reqA')
    {
        requestControl.acceptReq({sd: sdIn, pid: pidIn}, $(this));
    } else
        if (dest_ === 'reqR')
    {
        requestControl.cancelReq({t: 2, sd: sdIn, pid: pidIn}, $(this));
    }
});

    // list confirm request list
$(document).on('click ', '[href="#reqConfirm"]', function(e)
{
    e.preventDefault();
    if ($(this).parent().hasClass('higher'))
    {
        requestControl.listReqConfirm();
    }
});

    // confirm delete
$(document).on('click', '[href^="#Disagree"], [href^="#Agree"]', function(e)
{
    e.preventDefault();
    var pidIn = $(this).parent().attr('pid');
    var choice = $(this).attr('href');
    choice = choice.substring(1, 2);
    if (choice === 'D')
    {
        choice = 0;
    } else if (choice === 'A') {
        choice = 1;
    }
    if ((choice !== 0 && choice !== 1) || pidIn === undefined) {
        message.putError($errorParse(12));
        return;
    }
    requestControl.cfDelete({ch: choice, pid: pidIn}, $(this));
});

// search something
$(document).on('submit', searcher.id, function(e){
    e.preventDefault();
    var words = $(this).find('input[type="text"]').val();
    var userSearch = $(this).find('input[type="checkbox"]').prop('checked');
    searcher.lookUp(userSearch, words);
});

    // load task list
$(document).on('click', '[href^="#loadPj"]', function(e)
{
    e.preventDefault();
    var pid = $(this).parent().attr('pid');
    if (pid === undefined)
    {
        message.putError($errorParse(12));
    }
    projectControl.regist(pid, $(this).parent());
});

    // add task
$(document).on('submit', '#add-task-dialog form', function(e)
{
    e.preventDefault();
    var tname = $(this).find('#tname').val();
    var tdesc = $(this).find('#tdesc').val();
    var tdate = $(this).find('#tdate').val();
    var ttime = $(this).find('#ttime').val();
    if (tname.length < 1)
    {
        message.putError($errorParse(31));
        return;
    }
    if (tname.length > 32)
    {
        message.putError($errorParse(13));
        return;
    }
    if (tdate.length != 10){
        message.putError($errorParse(32));
        return;
    } else {
        var datePatt = /\d{4}-\d\d-\d\d/g;
        if (!datePatt.test(tdate))
        {
            message.putError($errorParse(34));
            return;
        }
    }
    if (ttime.length != 5){
        message.putError($errorParse(33));
        return;
    } else {
        var timePatt = /\d\d:\d\d/g;
        if (!timePatt.test(ttime))
        {
            message.putError($errorParse(35));
            return;
        }
    }
    var tdatetime = tdate + ' ' + ttime + ':00';
    if (0 > (Date.parse(tdatetime) - Date.parse((new Date()).toString())))
    {
        message.putError($errorParse(36));
        return;
    }
    taskControl.add({name: tname, desc: tdesc, dl: tdatetime}, $(this));
});

    // delete
$(document).on('click', '[href^="#rmT"]', function(e)
{
    e.preventDefault();
    var tid = $(this).parent().parent().parent().attr('tid');
    if (Number(tid) <= 0)
    {
        message.putError($errorParse(12));
        return;
    }
    taskControl.deleteTask(tid, $(this));
})

    // forward task
$(document).on('click', '[href^="#fwT"], [href^="#bwT"]', function(e)
{
    e.preventDefault();
    var c_state = $(this).parent().parent().parent().attr('tkind');
    var tidIn = $(this).parent().parent().parent().attr('tid');
    var direction = $(this).attr('href');
    if (c_state == '3')
    {
        message.putError($errorParse(14));
        return;
    }
    if ((c_state != '1' && c_state != '2') || Number(tidIn) <= 0)
    {
        message.putError($errorParse(12));
        return;
    }
    direction = direction.substring(1, 4);
    if (direction === 'fwT')
    {
        c_state = Number(c_state) + 1;
    } else
        if (direction === 'bwT')
    {
        c_state = Number(c_state) - 1;
    }
    taskControl.updateState({tid: tidIn, state: c_state}, $(this));
});

    // backward window
$(document).on('click', '[href="#return"]', function(e)
{
    e.preventDefault();
    projectControl.unregist($(this));
});

    // invite user
$(document).on('click', '[href^="#invite"]', function(e)
{
    e.preventDefault();
    var uid = $(this).attr('href');
    uid = uid.substring(7, uid.length);
    // get possible invite project list
    projectControl.getPIPL(uid, $(this));
});

    // dimiss parent only
$(document).on('click', '[ft="dimiss-parent-only"]', function(e)
{
    if ($(this).is('a'))
        e.preventDefault();
    $(this).parent().parent().remove();
    $(document).off('click', '[href^="#eselect"]');
});

    // dimiss parent direct
$(document).on('click', '[ft="dimiss-parent-direct"]', function()
{
    $(this).parent().removeClass('show-up');
}
);

    // rename form
$(document).on('submit', '#project-detail table form', function(e){
    e.preventDefault();
    var id = $(this).parent().parent().parent().attr('pid');
    var pname = $(this).find('input').val();
    if (pname.length > 32)
    {
        message.putError($errorParse(11));
        return;
    }
    projectControl.rename({pid: id, name: pname}, $(this));
});
    // log view
$(document).on('click', '[ft="logview"]', function(){
    projectControl.logView($(this).parent().parent().parent().attr('pid'), $(this));
});

// startup
$(document).ready(function(){
    $('.over-rem').addClass('w3-hide').removeClass('loading');
    if ($('#holdAll').hasClass('project-list'))
    {
        projectControl.loadList();
    }
    if ($('#holdAll').hasClass('task-list'))
    {
        taskControl.loadList();
    }
});

// register key press
window.addEventListener("keydown", function(e)
{
    if (e.defaultPrevented)
    {
        return;
    }
    if (e.keyCode !== undefined)
    {
        if (e.keyCode == 0x1B)
        {
            dialog.dimiss();
        }
    }
}, true);
