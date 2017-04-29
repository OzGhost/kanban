<?php
namespace app\controllers;
use Yii;
use yii\web\Controller;
use app\models\InnoDB;
class TaskController extends Controller
{
    /* add action: create new project */
    public function actionAdd()
    {
        $tname = Yii::$app->request->get('name');
        $tdesc = Yii::$app->request->get('desc');
        $tdl = Yii::$app->request->get('dl');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid') || !$session->has('pid'))
            return ['c' => 8];
        if (strlen($tname) > 32 || strlen($tname) < 1)
            return ['c' => 10];
        if (!preg_match('/\d{4}-\d\d-\d\d\s(\d\d:){2}\d\d/', $tdl) || strlen($tdl) != 19)
            return ['c' => 12];
        $rs = InnoDB::callNewTask($session->get('uid'), $session->get('pid'), $tname, $tdesc, $tdl);
        if (isset($rs['ms']))
        {
            if ($rs['ms'] == '-1' || $rs['ms'] == '-2' || $rs['ms'] == '-4')
                return ['c' => 12];
            if ($rs['ms'] == '-3')
                return ['c' => 23];
        }
        return [
            'c' => 0,
            't' => $rs
        ];
    }
    /* load task list */
    public function actionLoadlist()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid') || !$session->has('pid'))
            return ['c' => 8];
        $rs = InnoDB::callGetTaskList($session->get('uid'), $session->get('pid'));
        $session->close();
        if ($rs == '-1' || $rs == '-2' || $rs == '-3')
            return ['c' => 12];
        return $rs;
    }
    /* delete task */
    public function actionDelete()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid') || !$session->has('pid'))
            return ['c' => 8];
        /* get request params */
        $tid = intval(Yii::$app->request->get('tid'));
        if ($tid <= 0)
            return ['c' => 10];
        $session->close();
        $rs = InnoDB::callDelTask($session->get('uid'), $session->get('pid'), $tid);
        if ($rs != '0')
            return ['c' => 12];
        return ['c' => 0];
    }
    /* update task state */
    public function actionUpdatestate()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid') || !$session->has('pid'))
            return ['c' => 8];
        /* get request parameters */
        $tid = intval(Yii::$app->request->get('tid'));
        $state = Yii::$app->request->get('state');
        if ($tid <= 0 || ($state != '1' && $state != '2' && $state != '3'))
            return ['c' => 12];
        $rs = InnoDB::callUpdateTaskState($session->get('uid'), $session->get('pid'), $tid, intval($state));
        if ($rs == '-10')
            return ['c' => 24];
        if ($rs == '-8')
            return ['c' => 25];
        return [
            'c' => 0,
            's' => intval($rs)
        ];
    }
}
?>
