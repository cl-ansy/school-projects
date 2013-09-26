namespace Lansing_GraphicsFinal
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.btnDie = new System.Windows.Forms.Button();
            this.btnRotate = new System.Windows.Forms.Button();
            this.rotateTimer = new System.Windows.Forms.Timer(this.components);
            this.btnClear = new System.Windows.Forms.Button();
            this.btnLight = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // pictureBox1
            // 
            this.pictureBox1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.pictureBox1.Location = new System.Drawing.Point(12, 132);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(1112, 513);
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            // 
            // btnDie
            // 
            this.btnDie.Location = new System.Drawing.Point(157, 35);
            this.btnDie.Name = "btnDie";
            this.btnDie.Size = new System.Drawing.Size(121, 91);
            this.btnDie.TabIndex = 61;
            this.btnDie.Text = "Draw Dodecahedron";
            this.btnDie.UseVisualStyleBackColor = true;
            this.btnDie.Click += new System.EventHandler(this.btnDie_Click);
            // 
            // btnRotate
            // 
            this.btnRotate.Location = new System.Drawing.Point(284, 35);
            this.btnRotate.Name = "btnRotate";
            this.btnRotate.Size = new System.Drawing.Size(121, 91);
            this.btnRotate.TabIndex = 62;
            this.btnRotate.Text = "Roll 12-sided Die";
            this.btnRotate.UseVisualStyleBackColor = true;
            this.btnRotate.Click += new System.EventHandler(this.btnRotate_Click);
            // 
            // rotateTimer
            // 
            this.rotateTimer.Tick += new System.EventHandler(this.rotateTimer_Tick);
            // 
            // btnClear
            // 
            this.btnClear.Location = new System.Drawing.Point(411, 35);
            this.btnClear.Name = "btnClear";
            this.btnClear.Size = new System.Drawing.Size(118, 91);
            this.btnClear.TabIndex = 63;
            this.btnClear.Text = "Clear";
            this.btnClear.UseVisualStyleBackColor = true;
            this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
            // 
            // btnLight
            // 
            this.btnLight.Location = new System.Drawing.Point(536, 35);
            this.btnLight.Name = "btnLight";
            this.btnLight.Size = new System.Drawing.Size(122, 91);
            this.btnLight.TabIndex = 64;
            this.btnLight.Text = "Light On";
            this.btnLight.UseVisualStyleBackColor = true;
            this.btnLight.Click += new System.EventHandler(this.btnLight_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1136, 658);
            this.Controls.Add(this.btnLight);
            this.Controls.Add(this.btnClear);
            this.Controls.Add(this.btnRotate);
            this.Controls.Add(this.btnDie);
            this.Controls.Add(this.pictureBox1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Button btnDie;
        private System.Windows.Forms.Button btnRotate;
        private System.Windows.Forms.Timer rotateTimer;
        private System.Windows.Forms.Button btnClear;
        private System.Windows.Forms.Button btnLight;
    }
}

