<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "REQUESTS".
 *
 * @property integer $Sender
 * @property integer $Receiver
 * @property integer $ProjectID
 * @property integer $Type
 * @property string $RequestDate
 *
 * @property PROJECTS $project
 * @property USERS $sender
 * @property USERS $receiver
 */
class REQUESTS extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'REQUESTS';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['Sender', 'Receiver', 'ProjectID'], 'required'],
            [['Sender', 'Receiver', 'ProjectID', 'Type'], 'integer'],
            [['RequestDate'], 'safe'],
            [['ProjectID'], 'exist', 'skipOnError' => true, 'targetClass' => PROJECTS::className(), 'targetAttribute' => ['ProjectID' => 'ProjectID']],
            [['Sender'], 'exist', 'skipOnError' => true, 'targetClass' => USERS::className(), 'targetAttribute' => ['Sender' => 'UserID']],
            [['Receiver'], 'exist', 'skipOnError' => true, 'targetClass' => USERS::className(), 'targetAttribute' => ['Receiver' => 'UserID']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'Sender' => 'Sender',
            'Receiver' => 'Receiver',
            'ProjectID' => 'Project ID',
            'Type' => 'Type',
            'RequestDate' => 'Request Date',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProject()
    {
        return $this->hasOne(PROJECTS::className(), ['ProjectID' => 'ProjectID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getSender()
    {
        return $this->hasOne(USERS::className(), ['UserID' => 'Sender']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getReceiver()
    {
        return $this->hasOne(USERS::className(), ['UserID' => 'Receiver']);
    }
}
