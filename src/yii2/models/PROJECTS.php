<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "PROJECTS".
 *
 * @property integer $ProjectID
 * @property string $ProjectName
 * @property integer $Status
 * @property string $CreateDate
 * @property string $EndDate
 *
 * @property CI[] $cIs
 * @property LOGS[] $lOGSs
 * @property REQUESTS[] $rEQUESTSs
 * @property TASKS[] $tASKSs
 */
class PROJECTS extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'PROJECTS';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['ProjectName'], 'required'],
            [['Status'], 'integer'],
            [['CreateDate', 'EndDate'], 'safe'],
            [['ProjectName'], 'string', 'max' => 32],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'ProjectID' => 'Project ID',
            'ProjectName' => 'Project Name',
            'Status' => 'Status',
            'CreateDate' => 'Create Date',
            'EndDate' => 'End Date',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getCIs()
    {
        return $this->hasMany(CI::className(), ['ProjectID' => 'ProjectID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLOGSs()
    {
        return $this->hasMany(LOGS::className(), ['ProjectID' => 'ProjectID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getREQUESTSs()
    {
        return $this->hasMany(REQUESTS::className(), ['ProjectID' => 'ProjectID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getTASKSs()
    {
        return $this->hasMany(TASKS::className(), ['ProjectID' => 'ProjectID']);
    }
}
