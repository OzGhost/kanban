<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "LOGS".
 *
 * @property integer $LogID
 * @property integer $Maker
 * @property integer $ProjectID
 * @property integer $TaskID
 * @property string $ModifyDate
 * @property integer $Type
 * @property integer $SubType
 *
 * @property PROJECTS $project
 * @property TASKS $task
 * @property USERS $maker
 */
class LOGS extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'LOGS';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['Maker', 'ProjectID', 'TaskID'], 'required'],
            [['Maker', 'ProjectID', 'TaskID', 'Type', 'SubType'], 'integer'],
            [['ModifyDate'], 'safe'],
            [['ProjectID'], 'exist', 'skipOnError' => true, 'targetClass' => PROJECTS::className(), 'targetAttribute' => ['ProjectID' => 'ProjectID']],
            [['TaskID'], 'exist', 'skipOnError' => true, 'targetClass' => TASKS::className(), 'targetAttribute' => ['TaskID' => 'TaskID']],
            [['Maker'], 'exist', 'skipOnError' => true, 'targetClass' => USERS::className(), 'targetAttribute' => ['Maker' => 'UserID']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'LogID' => 'Log ID',
            'Maker' => 'Maker',
            'ProjectID' => 'Project ID',
            'TaskID' => 'Task ID',
            'ModifyDate' => 'Modify Date',
            'Type' => 'Type',
            'SubType' => 'Sub Type',
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
    public function getTask()
    {
        return $this->hasOne(TASKS::className(), ['TaskID' => 'TaskID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getMaker()
    {
        return $this->hasOne(USERS::className(), ['UserID' => 'Maker']);
    }
}
