<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "USERS".
 *
 * @property integer $UserID
 * @property string $UserName
 * @property string $Password
 *
 * @property CI[] $cIs
 * @property LOGS[] $lOGSs
 * @property REQUESTS[] $rEQUESTSs
 * @property REQUESTS[] $rEQUESTSs0
 * @property TASKS[] $tASKSs
 */
class USERS extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'USERS';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['UserName', 'Password'], 'required'],
            [['UserName'], 'string', 'max' => 32],
            [['Password'], 'string', 'max' => 64],
            [['UserName'], 'unique'],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'UserID' => 'User ID',
            'UserName' => 'User Name',
            'Password' => 'Password',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getCIs()
    {
        return $this->hasMany(CI::className(), ['UserID' => 'UserID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLOGSs()
    {
        return $this->hasMany(LOGS::className(), ['Maker' => 'UserID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getREQUESTSs()
    {
        return $this->hasMany(REQUESTS::className(), ['Sender' => 'UserID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getREQUESTSs0()
    {
        return $this->hasMany(REQUESTS::className(), ['Receiver' => 'UserID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getTASKSs()
    {
        return $this->hasMany(TASKS::className(), ['Affecter' => 'UserID']);
    }
}
