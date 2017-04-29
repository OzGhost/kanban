<?php
namespace app\controllers;
use Yii;
use yii\web\Controller;
use app\models\InnoDB;
class SearchController extends Controller
{
    public function actionIndex()
    {
        /* get request paramiter */
        $words = Yii::$app->request->get('words');
        $flag = intval(Yii::$app->request->get('flag'));
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        if (FALSE !== strpos($words, "'"))
            return ['c' => 10];
        $pattern = $this->getPattern($this->getToken($words));
        $session = Yii::$app->session;
        if (!$session->isActive)
            $session->open();
        if (!$session->has('uid'))
            return ['c' => 8];
        $kind = -1;
        if ($flag == 1)
        {
            $rs = InnoDB::callSearchUser($session->get('uid'), $pattern);
            $kind = -2;
        } else {
            $rs = InnoDB::callSearchProject($session->get('uid'), $pattern);
        }
        $session->close();
        return [
            'c' => $kind,
            'rs' => $rs
        ];
    }

    private function getToken($s){
        $rs = array();
        $index = strpos($s, ' ');
        $offset = 0;
        while (FALSE !== $index)
        {
            $rs[] = substr($s, $offset, ($index - $offset));
            $offset = $index + 1;
            $index = strpos($s, ' ', $offset);
        }
        $rs[] = substr($s, $offset, (strlen($s) - $offset));
        return $rs;
    }

    private function getPattern($arr)
    {
        $rs = '(';
        foreach($arr as $token)
        {
            $rs .= $token.'|';
        }
        $rs = substr($rs, 0, strlen($rs) - 1);
        $rs .= ')';
        return $rs;
    }
}
?>
