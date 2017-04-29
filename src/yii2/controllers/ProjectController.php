<?php
namespace app\controllers;
use Yii;
use yii\web\Controller;
use app\models\InnoDB;
use app\models\PROJECTS;
class ProjectController extends Controller
{
    /* add action: create new project */
    public function actionAdd()
    {
        $pname = Yii::$app->request->get('pname');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs = InnoDB::callNewProject($session->get('uid'),$pname);
        $session->close();
        if ($rs == '-2')
        {
            return ['c' => 5];
        }
        if ($rs == '-1')
        {
            return ['c' => 12];
        }
        return [
            'c' => 0,
            'pid' => $rs
        ];
    }

    /* load project list */
    public function actionLoadlist()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs = InnoDB::callGetProjectList($session->get('uid'));
        $session->close();
        if ($rs == '-1')
            return ['c' => 12];
        return $rs;
    }

    /* request delete project */
    public function actionReqdelete()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        /* get request params */
        $pid = Yii::$app->request->get('pid');
        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        /* query */
        $rs = intval(InnoDB::callReqDelProject($session->get('uid'), $pid));
        /* close session */
        $session->close();
        /* return json */
        if ($rs < 0)
        {
            return ['c' => 12];
        }
        return ['c' => $rs * -1];
    }

    /* confirm delete project */
    public function actionConfirmdelete()
    {
        /* get request input */
        $pid = intval(Yii::$app->request->get('pid'));
        $choice = intval(Yii::$app->request->get('theChoice'));
        /* choice response formatting */
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        if ($pid <= 0) {
            return ['c' => 0, 'ch' => 'false'];
        }
        if ($pid <= 0 || ($choice != 0 && $choice != 1))
            return ['c' => 10];
        /* start session */
        $session = Yii::$app->session;
        if ($session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        /* query */
        $rs = InnoDB::callConfirmDelete($session->get('uid'), $pid, $choice);
        $session->close();
        if (intval($rs) < 0)
            return ['c' => 12];
        return [
            'c' => 0,
            'ch' => $rs
        ];
    }
    /* regist project id for next access times */
    public function actionRegist()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        $pid = intval(Yii::$app->request->get('pid'));
        if ($pid <= 0)
            return ['c' => 10];
        $session->set('pid', $pid);
        $session->close();
        return ['c' => 0];
    }
    /* unregist project id */
    public function actionUnregist()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        $session->remove('pid');
        $session->close();
        return ['c' => 0];
    }
    /* get possible invite project list */
    public function actionGetpipl()
    {
        $rcv = Yii::$app->request->get('rcv');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        if ($rcv === null)
            return ['c' => 1];
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $rs = InnoDB::callGetPIPL($session->get('uid'), $rcv);
        $session->close();
        return [
            'f' => $rcv,
            'l' => $rs
        ];
    }
    /* invite someone to project */
    public function actionInvite()
    {
        $rcv = Yii::$app->request->get('uid');
        $pid = Yii::$app->request->get('pid');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        if ($rcv === null || $pid === null)
            return ['c' => 1];

        /* checking login */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];

        $rs = intval(InnoDB::callInviteToJoin($session->get('uid'), $rcv, $pid));
        if ($rs < 0)
            return ['c' => 12];

        $session->close();

        return ['c' => 0];
    }
    /* load detail of project */
    public function actionLoaddetail()
    {
        $pid = intval(Yii::$app->request->get('pid'));
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        if ($pid < 1)
            return ['c' => 12];

         /* checking login */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];

        $gi = InnoDB::callGetProjectInfo($pid);
        $ml = InnoDB::callGetMemberList($pid);
        $td = InnoDB::callGetTaskDetail($pid);
        $bd = InnoDB::callGetBorderTime($pid);

        $session->close();
        return [
            'gi' => $gi,
            'ml' => $ml,
            'td' => $td,
            'bd' => $bd
        ];
    }
    /* rename project */
    public function actionRename()
    {
        $pid = Yii::$app->request->get('pid');
        $name = Yii::$app->request->get('name');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

         /* checking login */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];

        $rs = InnoDB::callRenameProject($session->get('uid'), $pid, $name);
        $session->close();

        if ($rs == '-4')
            return ['c' => 5];
        if ($rs == '-3')
            return ['c' => 8];
        if ($rs != '0')
            return ['c' => 12];

        return ['c' => 0];
    }
    /* log view */
    public function actionLogview()
    {
        $pid = Yii::$app->request->get('pid');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

         /* checking login */
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];

        $rs = InnoDB::callGetLogList($pid);
        $session->close();

        return $rs;
    }
}
?>
