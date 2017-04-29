<?php

namespace app\controllers;

use Yii;
use yii\web\Controller;
use app\models\InnoDB;
use app\models\USERS;
use app\models\PROJECTS;
use yii\helpers\Html;

class SiteController extends Controller
{
    /**
     * @inheritdoc
     */
    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }

    /**
     * Displays homepage.
     *
     * @return string
     */
    public function actionIndex()
    {
        $session = Yii::$app->session;
        $data = [
            'mode' => 'entry',
            'uname' => '',
            'pname' => ''
        ];
        if (!$session->isActive)
        {
            $session->open();
        }
        if ($session->has('pid') && $session->has('uid'))
        {
            $data['mode'] = 'task-list';
            $user = USERS::find()->where(['UserID' => $session->get('uid')])->one();
            $data['uname'] = Html::encode($user->UserName);
            $pj = PROJECTS::find()->where(['ProjectID' => $session->get('pid')])->one();
            $data['pname'] = Html::encode($pj->ProjectName);
        } else
            if ($session->has('uid'))
        {
            $data['mode'] = 'project-list';
            $user = USERS::find()->where(['UserID' => $session->get('uid')])->one();
            $data['uname'] = Html::encode($user->UserName);
        }
        $session->close();
        return $this->render('index', $data);
    }

}
