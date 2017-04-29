<?php
namespace app\models;
use Yii;
/* object execute database transaction */
class InnoDB {
    /* call function checkingLogin */
    public static function callCheckingLogin($uname, $upass){
        $params = [':uname' => $uname, ':upass' => $upass];
        $reader = Yii::$app->db->createCommand('SELECT checkingLogin(:uname, :upass) AS ms')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* call procedure newUser */
    public static function callNewUser($uname, $upass)
    {
        $params = [':uname' => $uname, ':upass' => $upass];
        $reader = Yii::$app->db->createCommand('CALL newUser(:uname, :upass)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* call procedure getProjectList */
    public static function callGetProjectList($uid)
    {
        $reader = Yii::$app->db->createCommand('CALL getProjectList(:uid)')
            ->bindValue(':uid', $uid)
            ->queryAll();
        return $reader;
    }
    /* call procedure newProject */
    public static function callNewProject($uid, $pname)
    {
        $params = [':uid' => $uid, ':pname' => $pname];
        $reader = Yii::$app->db->createCommand('CALL newProject(:uid, :pname)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* call procedure reqDelProject */
    public static function callReqDelProject($uid, $pid)
    {
        $params = [':uid' => $uid, ':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL reqDelProject(:uid, :pid)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* call procedure confirmDelete */
    public static function callConfirmDelete($uid, $pid, $choice)
    {
        $params = [':uid' => $uid, ':pid' => $pid, ':choice' => $choice];
        $reader = Yii::$app->db->createCommand('CALL confirmDelete(:uid, :pid, :choice)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* search for user*/
    public static function callSearchUser($uid, $pattern)
    {
        $params = [':uid' => $uid, ':pattern' => $pattern];
        $reader = Yii::$app->db->createCommand('CALL searchUser(:uid, :pattern)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
    /* search for project */
    public static function callSearchProject($uid, $pattern)
    {
        $params = [':uid' => $uid, ':pattern' => $pattern];
        $reader = Yii::$app->db->createCommand('CALL searchProject(:uid, :pattern)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
    /* call procedure requestToJoin */
    public static function callRequestToJoin($uid, $pid)
    {
        $params = [':uid' => $uid, ':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL requestToJoin(:uid, :pid)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* get request sent list */
    public static function callGetRequestSendedList($uid)
    {
        $reader = Yii::$app->db->createCommand('CALL getRequestSendedList(:uid)')
            ->bindValue(':uid', $uid)
            ->queryAll();
        return $reader;
    }
    /* cancel or refuse request */
    public static function callRefuseRequest($rcv, $sd, $pid)
    {
        $params = [':rcv' => $rcv, ':sd' => $sd, ':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL refuseRequest(:rcv, :sd, :pid)')
            ->bindValues($params)
            ->query();
        return 0;
    }
    /* get request received list */
    public static function callGetRequestReceivedList($uid)
    {
        $reader = Yii::$app->db->createCommand('CALL getRequestReceivedList(:uid)')
            ->bindValue(':uid', $uid)
            ->queryAll();
        return $reader;
    }
    /* accept request */
    public static function callAcceptRequest($rcv, $sd, $pid)
    {
        $params = [':rcv' => $rcv, ':sd' => $sd, ':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL acceptRequest(:rcv, :sd, :pid)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* get list of confirm request */
    public static function callGetConfirmList($uid)
    {
        $reader = Yii::$app->db->createCommand('CALL getConfirmList(:uid)')
            ->bindValue(':uid', $uid)
            ->queryAll();
        return $reader;
    }
    /* get task list */
    public static function callGetTaskList($uid, $pid)
    {
        $params = [':uid' => $uid, ':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL getTaskList(:uid, :pid)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
    /* new task */
    public static function callNewTask($uid, $pid, $tname, $tdesc, $tdl)
    {
        $params = [':uid' => $uid, ':pid' => $pid, ':tname' => $tname, ':tdesc' => $tdesc, ':dl' => $tdl];
        $reader = Yii::$app->db->createCommand('CALL newTask(:uid, :pid, :tname, :tdesc, :dl)')
            ->bindValues($params)
            ->queryOne();
        return $reader;
    }
    /* delete task */
    public static function callDelTask($uid, $pid, $tid)
    {
        $params = [':uid' => $uid, ':pid' => $pid, ':tid' => $tid];
        $reader = Yii::$app->db->createCommand('CALL delTask(:uid, :pid, :tid)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* update task State */
    public static function callUpdateTaskState($uid, $pid, $tid, $state)
    {
        $params = [':uid' => $uid, ':pid' => $pid, ':tid' => $tid, ':state' => $state];
        $reader = Yii::$app->db->createCommand('CALL updateTaskState(:uid, :pid, :tid, :state)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* get possible invite project list */
    public static function callGetPIPL($uid, $rcv)
    {
        $params = [':uid' => $uid, ':rcv' => $rcv];
        $reader = Yii::$app->db->createCommand('CALL getPossibleInviteProjectList(:uid, :rcv)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
    /* invite to join */
    public static function callInviteToJoin($sd, $rcv, $pid)
    {
        $params = [':sd' => $sd, ':rcv' => $rcv, ':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL inviteToJoin(:sd, :rcv, :pid)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* get project info */
    public static function callGetProjectInfo($pid)
    {
        $params = [':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL getProjectInfo(:pid)')
            ->bindValues($params)
            ->queryOne();
        return $reader;
    }
    /* get member list */
    public static function callGetMemberList($pid)
    {
        $params = [':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL getMemberList(:pid)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
    /* get task detail */
    public static function callGetTaskDetail($pid)
    {
        $params = [':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL getTaskDetail(:pid)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
    /* get border time of project */
    public static function callGetBorderTime($pid)
    {
        $params = [':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL getBorderTime(:pid)')
            ->bindValues($params)
            ->queryOne();
        return $reader;
    }
    /* rename project */
    public static function callRenameProject($uid, $pid, $pname)
    {
        $params = [':uid' => $uid, ':pid' => $pid, ':pname' => $pname];
        $reader = Yii::$app->db->createCommand('CALL renameProject(:uid, :pid, :pname)')
            ->bindValues($params)
            ->queryOne();
        return $reader['ms'];
    }
    /* log view */
    public static function callGetLogList($pid)
    {
        $params = [':pid' => $pid];
        $reader = Yii::$app->db->createCommand('CALL getLogList(:pid)')
            ->bindValues($params)
            ->queryAll();
        return $reader;
    }
}
?>
