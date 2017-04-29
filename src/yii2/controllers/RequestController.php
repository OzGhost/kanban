<?php
namespace app\controllers;
use Yii;
use yii\web\Controller;
use app\models\InnoDB;
class RequestController extends Controller
{
    /* request to join the project */
    public function actionReqjoin()
    {
        /* get request paramiters */
        $pid = Yii::$app->request->get('pid');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        if ($pid === null)
            return ['c' => 10];
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs = InnoDB::callRequestToJoin($session->get('uid'), $pid);
        if ($rs == '-1')
            return ['c' => 9];
        return ['c' => 0];
    }
    /* list request was sent */
    public function actionListreqsent()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs = InnoDB::callGetRequestSendedList($session->get('uid'));
        $session->close();
        return $rs;
    }
    /* list request was received */
    public function actionListreqreceived()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs =  InnoDB::callGetRequestReceivedList($session->get('uid'));
        $session->close();
        return $rs;
    }
    /* cancel request */
    public function actionCancelreq()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        /* get request params */
        $pid = intval(Yii::$app->request->get('pid'));
        $rcv = null;
        $sd = null;
        $t = Yii::$app->request->get('t');
        /* $t = '1'; */
        if ($t === '1')
        {
            $rcv = intval(Yii::$app->request->get('rcv'));
            $sd = intval($session->get('uid'));
        } else
            if ($t === '2')
            {
                $rcv = intval($session->get('uid'));
                $sd = intval(Yii::$app->request->get('sd'));
            } else {
                return ['c' => 10];
            }
        /* $rcv = 2; $sd = 3; $pid = 6; */
        /* check input */
        if ($rcv == null || $sd == null || $pid == null)
        {
            return ['c' => 10];
        }
        InnoDB::callRefuseRequest($rcv, $sd, $pid);
        $session->close();
        return ['c' => 0];
    }
    /* accept request */
    public function actionAcceptreq()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        /* get request parameter */
        $sd = intval(Yii::$app->request->get('sd'));
        $pid = intval(Yii::$app->request->get('pid'));
        /* check input */
        if ($sd <= 0 || $pid <= 0)
        {
            return ['c' => 10];
        }
        $rs = InnoDB::callAcceptRequest($session->get('uid'), $sd, $pid);
        if ($rs == '-1')
        {
            return ['c' => 9];
        }
        $session->close();
        return [
            'c' => 0,
            't' => intval($rs)
        ];
    }
    /* get list confirm request */
    public function actionListreqconfirm()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs = InnoDB::callGetConfirmList($session->get('uid'));
        return $rs;
    }
    public function actionConfirmdelete()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        /* get request parameter */
        $pid = intval(Yii::$app->request->get('pid'));
        $choice = intval(Yii::$app->request->get('ch'));
        if ($pid <= 0)
        {
            return ['c' => 10];
        }
        $rs = InnoDB::callConfirmDelete($session->get('uid'), $pid, $choice);
        return [
            'c' => 0,
            'ch' => $rs
        ];
    }
}
?>
