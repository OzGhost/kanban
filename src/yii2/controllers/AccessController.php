<?php
namespace app\controllers;
use Yii;
use yii\web\Controller;
use app\models\InnoDB;
use app\models\USERS;
class AccessController extends Controller
{
    /* default action */
    public function actionIndex()
    {
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        return ['rs' => 'null'];
    }

    /* login action */
    public function actionLogin()
    {
        $uname = Yii::$app->request->post('uname');
        $upass = Yii::$app->request->post('upass');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        /* case null input */
        if ($uname == null || $upass == null)
        { return ['c' => 1]; }

        /* create inno to call function */
        $rs = InnoDB::callCheckingLogin($uname, $upass);

        /* case login failure */
        if ($rs == '-1')
        { return ['c' => 21]; }
        if ($rs == '-2')
        { return ['c' => 22]; }

        /* open session */
        $session = Yii::$app->session;
        if (!$session->isActive)
        {
            $session->open();
        }
        /* get user id from database */
        $user = USERS::find()
            ->where(['UserName' => $uname, 'Password' => $upass])
            ->one();
        /* set session */
        $session->set('uid', $user->UserID);
        $session->close();
        return [
            'c' => 0
        ];
    }

    /* register action */
    public function actionReg()
    {
        $uname = Yii::$app->request->post('uname');
        $upass = Yii::$app->request->post('upass');
        $repass = Yii::$app->request->post('repass');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        /* case missing input */
        if ($uname == null || $upass == null || $repass == null)
        {
            return ['c' => 1];
        }
        /* case retype password not matched */
        if ($upass !== $repass)
        {
            return ['c' => 3];
        }

        /* create inno to call database function */
        $rs = InnoDB::callNewUser($uname, $upass);

        /* case execute sql failure */
        if ($rs == '-1')
        {
            return ['c' => 4];
        }
        if ($rs == '-2')
        {
            return ['c' => 9];
        }
        return [
            'c' => 0
        ];
    }

    /* logout action */
    public function actionLogout()
    {
        $session = Yii::$app->session;
        if (!$session->isActive)
        {
            $session->open();
        }
        $session->destroy();
        $session->close();
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        return ['c' => 0];
    }
}
?>
