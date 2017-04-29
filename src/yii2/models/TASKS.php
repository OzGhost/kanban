<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "TASKS".
 *
 * @property integer $TaskID
 * @property string $TaskName
 * @property integer $ProjectID
 * @property string $Desc_
 * @property integer $Status
 * @property string $CreateDate
 * @property string $StartDate
 * @property string $CompleteDate
 * @property integer $Affecter
 *
 * @property LOGS[] $lOGSs
 * @property PROJECTS $project
 * @property USERS $affecter
 */
class TASKS extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'TASKS';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['TaskName', 'ProjectID', 'Affecter'], 'required'],
            [['ProjectID', 'Status', 'Affecter'], 'integer'],
            [['Desc_'], 'string'],
            [['CreateDate', 'StartDate', 'CompleteDate'], 'safe'],
            [['TaskName'], 'string', 'max' => 32],
            [['TaskName', 'ProjectID'], 'unique', 'targetAttribute' => ['TaskName', 'ProjectID'], 'message' => 'The combination of Task Name and Project ID has already been taken.'],
            [['ProjectID'], 'exist', 'skipOnError' => true, 'targetClass' => PROJECTS::className(), 'targetAttribute' => ['ProjectID' => 'ProjectID']],
            [['Affecter'], 'exist', 'skipOnError' => true, 'targetClass' => USERS::className(), 'targetAttribute' => ['Affecter' => 'UserID']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'TaskID' => 'Task ID',
            'TaskName' => 'Task Name',
            'ProjectID' => 'Project ID',
            'Desc_' => 'Desc',
            'Status' => 'Status',
            'CreateDate' => 'Create Date',
            'StartDate' => 'Start Date',
            'CompleteDate' => 'Complete Date',
            'Affecter' => 'Affecter',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLOGSs()
    {
        return $this->hasMany(LOGS::className(), ['TaskID' => 'TaskID']);
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
    public function getAffecter()
    {
        return $this->hasOne(USERS::className(), ['UserID' => 'Affecter']);
    }
}
