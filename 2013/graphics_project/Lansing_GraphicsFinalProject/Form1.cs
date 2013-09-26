using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Collections;


namespace Lansing_GraphicsFinal
{
    public partial class Form1 : Form
    {
        point Light;
        bool lightOn = false;

        //initialized dodecahedron object
        Dodecahedron d1;
        public Form1()
        {
            //supposedly reduces the flicker, though I'm not sure if it's actually doing anything or if I'm using it correctly
            this.DoubleBuffered = true;

            InitializeComponent();

            //Create the canvas to draw on
            pictureBox1.Image = new Bitmap(pictureBox1.Width, pictureBox1.Height);

            //create the light point
            Light = new point();

            //create the dodecahedron object
            d1 = new Dodecahedron(500, 200, 100, 100, Light, lightOn);
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        //"Draw Dodecahedron" button
        private void btnDie_Click(object sender, EventArgs e)
        {
            d1.draw(pictureBox1, Color.Blue);
        }

        //"Roll 12-sided Die" button
        private void btnRotate_Click(object sender, EventArgs e)
        {
            if (btnRotate.Text == "Roll 12-sided Die")
            {
                rotateTimer.Enabled = true;
                btnRotate.Text = "Stop";
            }

            else
            {
                rotateTimer.Enabled = false;
                btnRotate.Text = "Roll 12-sided Die";
            }
        }

        //"Clear" button
        private void btnClear_Click(object sender, EventArgs e)
        {
            pictureBox1.Image = new Bitmap(pictureBox1.Width, pictureBox1.Height);
        }

        //timer that rotates and draws the die with each tick
        private void rotateTimer_Tick(object sender, EventArgs e)
        {
            d1.rotate();
            d1.drawTextures(pictureBox1, lightOn);
        }

        //"Light On/Off" button
        private void btnLight_Click(object sender, EventArgs e)
        {
            if (btnLight.Text == "Light On")
            {
                lightOn = true;
                btnLight.Text = "Light Off";
            }
            else
            {
                lightOn = false;
                btnLight.Text = "Light On";
            }
        }
    }



    //********************************************************************************************
    //Point class used by the edge class
    public class point
    {
        public double x;
        public double y;
        public double z;

        //Default constructor
        public point()
        {
            x = 0.0; y = 0.0; z = 0.0;
        }

        //Constructor to initialize x and y for 2D (makes z=0)
        public point(double x, double y)
        {
            this.x = x; this.y = y; this.z = 0;
        }

        //Constructor to initialize x, y and z for 3D
        public point(double x, double y, double z)
        {
            this.x = x; this.y = y; this.z = z;
        }
    }



    //********************************************************************************************
    //Defines an edge for a graphicsObject2D and graphicsObject3D
    public class edge
    {
        public point p1;
        public point p2;

        //An edge is defined by 2 points
        public edge(point p1, point p2)
        {
            //Create a new set of points
            this.p1 = new point(p1.x, p1.y, p1.z);
            this.p2 = new point(p2.x, p2.y, p2.z);
        }

        //Default constructor
        public edge()
        {
            //Create a new set of points
            this.p1 = new point(0,0,0);
            this.p2 = new point(0,0,0);
        }
    }

    public class Face
    {
        //initialize variables
        public point p1, p2, p3, p4, p5;
        public edge e1, e2, e3, e4, e5;
        public Color c;
        public String imageLoc;
        public int maxZ = 0;
        //default constructor
        public Face() { }

        //5 points for a hexagon and its color
        public Face(point point1, point point2, point point3, point point4, point point5, Color color)
        {
            this.p1 = point1;
            this.p2 = point2;
            this.p3 = point3;
            this.p4 = point4;
            this.p5 = point5;
            this.e1 = new edge(point1, point2);
            this.e2 = new edge(point2, point3);
            this.e3 = new edge(point3, point4);
            this.e4 = new edge(point4, point5);
            this.e5 = new edge(point5, point1);
            this.c = color;
        }

        //5 points for a hexagon, its color, and the file location of its png
        public Face(point point1, point point2, point point3, point point4, point point5, Color color, String imageL)
        {
            this.p1 = point1;
            this.p2 = point2;
            this.p3 = point3;
            this.p4 = point4;
            this.p5 = point5;
            this.e1 = new edge(point1, point2);
            this.e2 = new edge(point2, point3);
            this.e3 = new edge(point3, point4);
            this.e4 = new edge(point4, point5);
            this.e5 = new edge(point5, point1);
            this.c = color;
            this.imageLoc = imageL;
        }
    }

    //********************************************************************************************
    //Class used as a basis for all polygonal figures (can be used for 3d too!)
    public class graphicsObject
    {
        //Stores the visibility of the graphics2D object
        public bool visible = false;

        //Stores the edges and faces of the graphics object
        public ArrayList edges;
        public ArrayList faces;

        //Used to position the graphics object when drawn
        public double[,] position = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { 0, 0, 0, 1 } };

        //Default constructor (needed for inheritance
        public graphicsObject() { this.edges = new ArrayList(); this.faces = new ArrayList(); }

        //Constructor to create a graphicsObject2D out of an ArrayList of edges and faces
        public graphicsObject(ArrayList edges)
        {
            this.edges = new ArrayList();
            foreach (edge e in edges) this.edges.Add(e);
            this.faces = new ArrayList();
            foreach (Face f in faces) this.faces.Add(f);
        }

        //Draws the graphics object in the PictureBox "picbox1"
        public void draw(PictureBox picbox1, Color c)
        {
            visible = true;
            foreach (edge e in this.edges)
            {
                //Create a matrix of the original points for the edge
                double[,] pointMatrix = { { e.p1.x, e.p1.y, e.p1.z, 1 }, { e.p2.x, e.p2.y, e.p2.z, 1 } };

                //Move the edges to the new location
                double[,] movedPoints = matrix.matMult(pointMatrix, position);

                edge movedEdge = new edge();


                //Get the edge back
                movedEdge.p1.x = movedPoints[0, 0];
                movedEdge.p1.y = movedPoints[0, 1];
                movedEdge.p1.z = movedPoints[0, 2];
                movedEdge.p2.x = movedPoints[1, 0];
                movedEdge.p2.y = movedPoints[1, 1];
                movedEdge.p2.z = movedPoints[1, 2];
                
                //Project the edge to 2D
                edge e1 = projectEdge(movedEdge, 2000);

                //Draw the line at the new location (c = color)
                lines.DDA((int)e1.p1.x, (int)e1.p1.y, (int)e1.p2.x, (int)e1.p2.y, picbox1, c);
            }
        }


        //Hides the graphicsObject
        public void hide(PictureBox p1)
        {
            p1.Image = new Bitmap(p1.Width, p1.Height);
            visible = false;
        }

        //Changes the position of the object
        public void changePosition(double[,] transform)
        {
            position = matrix.matMult(position, transform);
        }

        //Returns all the vertices of the graphicsObject
        public ArrayList getVertices()
        {
            ArrayList v = new ArrayList();
            foreach(edge e in edges) v.Add(e.p2);
            return v;
        }

        //Returns the center of the graphicsObject
        public point getCenter()
        {
            double xCenter = 0;
            double yCenter = 0;
            double zCenter = 0;

            ArrayList v = getVertices();
            
            //Average the x and y coordinates of the vertices
            foreach (point p in v)
            {
                xCenter += p.x; yCenter += p.y; zCenter += p.z;
            }
            xCenter = xCenter / v.Count;
            yCenter = yCenter / v.Count;
            zCenter = zCenter / v.Count;

            //Move the center using the position matrix
            double[,] movedCenter = 
                matrix.matMult(new double[,] {{xCenter,yCenter,zCenter,1}},position);

            //Return the result
            return new point(movedCenter[0,0], movedCenter[0,1], movedCenter[0,2]);
        }


        //Projects an edge using one point perspective with point of infinity at "d"
        protected edge projectEdge(edge e, double d)
        {
            return new edge(new point(e.p1.x*d/(d-e.p1.z),e.p1.y*d/(d-e.p1.z)),new point(e.p2.x*d/(d-e.p2.z),e.p2.y*d/(d-e.p2.z)));
        }
    }  //End graphicsObject

    public class Dodecahedron : graphicsObject
    {
        point Light;
        bool lightOn;
        //Origin (x, y, z) and scalar size 
        public Dodecahedron(int x, int y, int z, double size, point Light, bool lightOn)//Origin (x,y,z)
        {
            this.Light = Light;
            this.lightOn = lightOn;

            //symmetry ratio to calculate points
            double goldenRatio = 1.618;
            //scale the ratio by size
            int r = (int)Math.Round(goldenRatio * size);//if size = 20; r = 32
            int oneOverR = (int)Math.Round(size * (1 / goldenRatio));//if size = 20; oneOverR = 12

            //Plot points and faces as outlined in "Design.png"

            point c1 = new point(x - size, y + size, z - size);
            point c2 = new point(x + size, y + size, z - size);
            point c3 = new point(x + size, y - size, z - size);
            point c4 = new point(x - size, y - size, z - size);
            point c5 = new point(x - size, y + size, z + size);
            point c6 = new point(x + size, y + size, z + size);
            point c7 = new point(x + size, y - size, z + size);
            point c8 = new point(x - size, y - size, z + size);
            point g1 = new point(x, y + oneOverR, z - r);//if origin = (100, 100, 100), size = 20; g1 = (100, 112, 68); (0, 1/r, -r)
            point g2 = new point(x, y + oneOverR, z + r);
            point g3 = new point(x, y - oneOverR, z - r);
            point g4 = new point(x, y - oneOverR, z + r);
            point b1 = new point(x - oneOverR, y + r, z);
            point b2 = new point(x + oneOverR, y + r, z);
            point b3 = new point(x + oneOverR, y - r, z);
            point b4 = new point(x - oneOverR, y - r, z);
            point p1 = new point(x + r, y, z - oneOverR);
            point p2 = new point(x - r, y, z - oneOverR);
            point p3 = new point(x - r, y, z + oneOverR);
            point p4 = new point(x + r, y, z + oneOverR);

            //Face(point 1, point 2, point 3, point 4, point 5, face color, image location)
            Face f1 = new Face(c2, p1, c3, g3, g1, Color.Red, @"Images\1.png");//1
            Face f2 = new Face(c2, b2, c6, p4, p1, Color.Orange, @"Images\2.png");//2
            Face f3 = new Face(p1, p4, c7, b3, c3, Color.Yellow, @"Images\3.png");//3
            Face f4 = new Face(c3, b3, b4, c4, g3, Color.Green, @"Images\4.png");//4
            Face f5 = new Face(g3, c4, p2, c1, g1, Color.Blue, @"Images\5.png");//5
            Face f6 = new Face(g1, c1, b1, b2, c2, Color.Red, @"Images\6.png");//6
            Face f7 = new Face(c5, g2, g4, c8, p3, Color.Orange, @"Images\12.png");//12
            Face f8 = new Face(c5, b1, b2, c6, g2, Color.Yellow, @"Images\9.png");//9
            Face f9 = new Face(g2, c6, p4, c7, g4, Color.Green, @"Images\8.png");//8
            Face f10 = new Face(g4, c7, b3, b4, c8, Color.Blue, @"Images\7.png");//7
            Face f11 = new Face(c8, b4, c4, p2, p3, Color.Red, @"Images\11.png");//11
            Face f12 = new Face(p3, p2, c1, b1, c5, Color.Orange, @"Images\10.png");//10

            //add all the edges to the edges arraylist
            edges.Add(f1.e1); edges.Add(f1.e2); edges.Add(f1.e3); edges.Add(f1.e4); edges.Add(f1.e5);
            edges.Add(f2.e1); edges.Add(f2.e2); edges.Add(f2.e3); edges.Add(f2.e4); edges.Add(f2.e5);
            edges.Add(f3.e1); edges.Add(f3.e2); edges.Add(f3.e3); edges.Add(f3.e4); edges.Add(f3.e5);
            edges.Add(f4.e1); edges.Add(f4.e2); edges.Add(f4.e3); edges.Add(f4.e4); edges.Add(f4.e5);
            edges.Add(f5.e1); edges.Add(f5.e2); edges.Add(f5.e3); edges.Add(f5.e4); edges.Add(f5.e5);
            edges.Add(f6.e1); edges.Add(f6.e2); edges.Add(f6.e3); edges.Add(f6.e4); edges.Add(f6.e5);
            edges.Add(f7.e1); edges.Add(f7.e2); edges.Add(f7.e3); edges.Add(f7.e4); edges.Add(f7.e5);
            edges.Add(f8.e1); edges.Add(f8.e2); edges.Add(f8.e3); edges.Add(f8.e4); edges.Add(f8.e5);
            edges.Add(f9.e1); edges.Add(f9.e2); edges.Add(f9.e3); edges.Add(f9.e4); edges.Add(f9.e5);
            edges.Add(f10.e1); edges.Add(f10.e2); edges.Add(f10.e3); edges.Add(f10.e4); edges.Add(f10.e5);
            edges.Add(f11.e1); edges.Add(f11.e2); edges.Add(f11.e3); edges.Add(f11.e4); edges.Add(f11.e5);
            edges.Add(f12.e1); edges.Add(f12.e2); edges.Add(f12.e3); edges.Add(f12.e4); edges.Add(f12.e5);

            //add all the faces to the faces arraylist
            faces.Add(f1); faces.Add(f2); faces.Add(f3); faces.Add(f4); faces.Add(f5); faces.Add(f6);
            faces.Add(f7); faces.Add(f8); faces.Add(f9); faces.Add(f10); faces.Add(f11); faces.Add(f12);
        }

        public void drawTextures(PictureBox picbox1, bool lightOn)
        {
            visible = true;
            //create new graphics object
            Graphics g = picbox1.CreateGraphics();
            //initialize the brush, center point, and facenumber image file
            Brush b;
            point center = new point();
            Image faceNumber;

            //clears the current graphics
            g.Clear(picbox1.BackColor);

            //set max z value of each face and sort the faces arraylist by those z values
            setMaxZValue();
            sortByZ();

            //fill the polygon of each face using its points
            foreach (Face f in this.faces)
            {
                //store points in matrix
                double[,] pointMatrix = { { f.p1.x, f.p1.y, f.p1.z, 1 },
                                        { f.p2.x, f.p2.y, f.p2.z, 1 },
                                        { f.p3.x, f.p3.y, f.p3.z, 1 },
                                        { f.p4.x, f.p4.y, f.p4.z, 1 },
                                        { f.p5.x, f.p5.y, f.p5.z, 1 },};

                //multiply matrices to move the face points
                double[,] movedFaces = matrix.matMult(pointMatrix, position);

                //calculate x y and z of the center point
                center.x = ((movedFaces[0, 0] + movedFaces[1, 0] + movedFaces[2, 0] + movedFaces[3, 0] + movedFaces[4, 0]) / 5);
                center.y = ((movedFaces[0, 1] + movedFaces[1, 1] + movedFaces[2, 1] + movedFaces[3, 1] + movedFaces[4, 1]) / 5);
                center.z = ((movedFaces[0, 2] + movedFaces[1, 2] + movedFaces[2, 2] + movedFaces[3, 2] + movedFaces[4, 2]) / 5);

                //draw the faceNumber png as specified by imageLoc in the params
                //at the center of the current face with width and height of the image
                faceNumber = Image.FromFile(f.imageLoc);
                //havent been able to find a way to give images a z-index, which kinda ruins the die face number idea
                g.DrawImage(faceNumber, new Rectangle((int)center.x, (int)center.y, faceNumber.Width, faceNumber.Height));


                //////////////////////////////////////////////////Point light source
                //Form the vector from the point light source to the center of the polygon
                //vector v1 = p1 - p0
                vector3D v1 = new vector3D(f.p2.x - f.p1.x, f.p2.y - f.p1.y, f.p2.z - f.p1.z);

                //vector v2 = p2 - p0
                vector3D v2 = new vector3D(f.p3.x - f.p1.x, f.p3.y - f.p1.y, f.p3.z - f.p1.z);

                //Normal vector N = v1 x v2
                vector3D N = v2.cross(v1);
                vector3D lightVector = new vector3D(Light.x - center.x, Light.y - center.y, Light.z - center.z);

                double angle = Math.Abs(N.getAngle(lightVector));
                double multiplier;

                //Calculate the multiplier
                if (angle <= Math.PI / 2) multiplier = (Math.PI / 2 - angle) / Math.PI / 2;
                else multiplier = 0;


                //Get the color
                Color c = Color.FromArgb(
                    (byte)(f.c.R * multiplier),
                    (byte)(f.c.G * multiplier),
                    (byte)(f.c.B * multiplier));

                //if the light is on, use the color calculated by the light and face color
                //else use the default face color
                if (lightOn)
                {
                    b = new SolidBrush(c);
                }
                else
                {
                    b = new SolidBrush(f.c);
                }
                ///////////////////////////////////////////////////


                //fill a polygon of the faces points with its color as specified in the params
                g.FillPolygon(b, new Point[] { new Point((int)movedFaces[0, 0], (int)movedFaces[0, 1]), 
                                               new Point((int)movedFaces[1, 0], (int)movedFaces[1, 1]), 
                                               new Point((int)movedFaces[2, 0], (int)movedFaces[2, 1]),
                                               new Point((int)movedFaces[3, 0], (int)movedFaces[3, 1]),
                                               new Point((int)movedFaces[4, 0], (int)movedFaces[4, 1])});
            }
        }

        public void setMaxZValue()
        {
            //set max z value of each face for sorting purposes
            foreach (Face face in this.faces)
            {
                //create an array of ints of the faces' z values
                int[] zArray = { (int)face.p1.z, (int)face.p2.z, (int)face.p3.z, (int)face.p4.z, (int)face.p5.z };
                //get the max int from the array and store it in face.maxZ
                face.maxZ = zArray.Max();
            }
        }

        public void sortByZ()
        {
            Object temp;
            //bubble sort arraylist faces based on max z value of each face
            for (int i = 0; i < this.faces.Count - 1; i++)
            {
                for (int j = 0; j < this.faces.Count - 1; j++)
                {
                    //put faces with highest z values at the beginning of the list
                    //so that they are drawn first
                    if (((Face)this.faces[j]).maxZ < ((Face)this.faces[j + 1]).maxZ)
                    {
                        temp = this.faces[j];
                        this.faces[j] = this.faces[j + 1];
                        this.faces[j + 1] = temp;
                    }
                }
            }
        }
        //draw the dodecahedron
        public void draw(PictureBox picbox1, Color c)
        {
            visible = true;
            foreach (edge e in this.edges)
            {
                //Create a matrix of the original points for the edge
                double[,] pointMatrix = { { e.p1.x, e.p1.y, e.p1.z, 1 }, { e.p2.x, e.p2.y, e.p2.z, 1 } };

                //Move the edges to the new location
                double[,] movedPoints = matrix.matMult(pointMatrix, position);

                edge movedEdge = new edge();

                //Get the edge back
                movedEdge.p1.x = movedPoints[0, 0];
                movedEdge.p1.y = movedPoints[0, 1];
                movedEdge.p1.z = movedPoints[0, 2];
                movedEdge.p2.x = movedPoints[1, 0];
                movedEdge.p2.y = movedPoints[1, 1];
                movedEdge.p2.z = movedPoints[1, 2];

                //Project the edge to 2D
                edge e1 = projectEdge(movedEdge, 2000);

                //Draw the line at the new location (c = color)
                lines.DDA((int)e1.p1.x, (int)e1.p1.y, (int)e1.p2.x, (int)e1.p2.y, picbox1, c);
            }
        }

        //rotate the polygon
        public void rotate()
        {
            double angle = 1.0 * Math.PI / 180.0;

            //rotation matrices for x y and z
            double[,] rotateX = {{1,0,0,0},
                                {0,Math.Cos(angle),Math.Sin(angle),0},
                                {0,-Math.Sin(angle),Math.Cos(angle),0},
                                {0,0,0,1}};;

            double[,] rotateY = {{Math.Cos(angle),0,Math.Sin(angle),0},
                                {0,1,0,0},
                                {-Math.Sin(angle),0,Math.Cos(angle),0},
                                {0,0,0,1}};

            double[,] rotateZ = {{Math.Cos(angle),Math.Sin(angle),0,0},
                                {-Math.Sin(angle),Math.Cos(angle),0,0},
                                {0,0,1,0},{0,0,0,1}};

            //get the center
            point center = getCenter();

            double[,] moveToOrigin = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { -center.x, -center.y, -center.z, 1 } };
            double[,] moveBackFromOrigin = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { center.x, center.y, center.z, 1 } };

            changePosition(moveToOrigin);
            changePosition(rotateX);
            changePosition(rotateY);
            changePosition(rotateZ);

            changePosition(moveBackFromOrigin);
        }
    }//end class dodecahedron

    //********************************************************************************************
    //Defining a cube class - inherit the graphicsObject class
    public class cube : graphicsObject
    {
        point[][] faces = new point[6][];
        Color[] faceColors;
        point Light;
        public cube(point p1, point p2, point p3, point p4, point p5, point p6, point p7, point p8, Color[] c, point Light)
        {

            this.Light = Light;
            faceColors = c;
            for (int i = 0; i < 6; i++)
            {
                faces[i] = new point[4];
               for (int j = 0; j < 4; j++) faces[i][j] = new point();
            }


            //Define the front face
            faces[0][0].x = p8.x;
            faces[0][0].y = p8.y;
            faces[0][0].z = p8.z;
            faces[0][1].x = p7.x;
            faces[0][1].y = p7.y;
            faces[0][1].z = p7.z;
            faces[0][2].x = p6.x;
            faces[0][2].y = p6.y;
            faces[0][2].z = p6.z;
            faces[0][3].x = p5.x;
            faces[0][3].y = p5.y;
            faces[0][3].z = p5.z;

            //Define the back face
            faces[1][0].x = p1.x;
            faces[1][0].y = p1.y;
            faces[1][0].z = p1.z;
            faces[1][1].x = p2.x;
            faces[1][1].y = p2.y;
            faces[1][1].z = p2.z;
            faces[1][2].x = p3.x;
            faces[1][2].y = p3.y;
            faces[1][2].z = p3.z;
            faces[1][3].x = p4.x;
            faces[1][3].y = p4.y;
            faces[1][3].z = p4.z;

            //Define the left face
            faces[2][0].x = p2.x;
            faces[2][0].y = p2.y;
            faces[2][0].z = p2.z;
            faces[2][1].x = p6.x;
            faces[2][1].y = p6.y;
            faces[2][1].z = p6.z;
            faces[2][2].x = p7.x;
            faces[2][2].y = p7.y;
            faces[2][2].z = p7.z;
            faces[2][3].x = p3.x;
            faces[2][3].y = p3.y;
            faces[2][3].z = p3.z;

            //Define the right face
            faces[3][0].x = p4.x;
            faces[3][0].y = p4.y;
            faces[3][0].z = p4.z;
            faces[3][1].x = p8.x;
            faces[3][1].y = p8.y;
            faces[3][1].z = p8.z;
            faces[3][2].x = p5.x;
            faces[3][2].y = p5.y;
            faces[3][2].z = p5.z;
            faces[3][3].x = p1.x;
            faces[3][3].y = p1.y;
            faces[3][3].z = p1.z;

            //Define the top face
            faces[4][0].x = p5.x;
            faces[4][0].y = p5.y;
            faces[4][0].z = p5.z;
            faces[4][1].x = p6.x;
            faces[4][1].y = p6.y;
            faces[4][1].z = p6.z;
            faces[4][2].x = p2.x;
            faces[4][2].y = p2.y;
            faces[4][2].z = p2.z;
            faces[4][3].x = p1.x;
            faces[4][3].y = p1.y;
            faces[4][3].z = p1.z;

            //Define the bottom face
            faces[5][0].x = p4.x;
            faces[5][0].y = p4.y;
            faces[5][0].z = p4.z;
            faces[5][1].x = p3.x;
            faces[5][1].y = p3.y;
            faces[5][1].z = p3.z;
            faces[5][2].x = p7.x;
            faces[5][2].y = p7.y;
            faces[5][2].z = p7.z;
            faces[5][3].x = p8.x;
            faces[5][3].y = p8.y;
            faces[5][3].z = p8.z;



            //Form edges from the points
            edge e1 = new edge(p1, p2); edge e2 = new edge(p2, p3); edge e3 = new edge(p3, p4); edge e4 = new edge(p4, p1);
            edge e5 = new edge(p5, p6); edge e6 = new edge(p6, p7); edge e7 = new edge(p7, p8); edge e8 = new edge(p8, p5);
            edge e9 = new edge(p1, p5); edge e10 = new edge(p2, p6); edge e11 = new edge(p3, p7); edge e12 = new edge(p4, p8);

            //Add the edges to the cube
            edges.Add(e1); edges.Add(e2); edges.Add(e3); edges.Add(e4);
            edges.Add(e5); edges.Add(e6); edges.Add(e7); edges.Add(e8);
            edges.Add(e9); edges.Add(e10); edges.Add(e11); edges.Add(e12); 
        }

        //Draws the graphics object in the PictureBox "picbox1"
        public void draw(PictureBox picbox1)
        {
            visible = true;
            double[][,] movedPoints = new double[6][,];
            //Loop through each face
            for(int i=0; i<6; i++)
            {
                //Create a matrix of the original points for the face
                double[,] pointMatrix = { { faces[i][0].x, faces[i][0].y, faces[i][0].z, 1 }, { faces[i][1].x, faces[i][1].y, faces[i][1].z, 1 }, { faces[i][2].x, faces[i][2].y, faces[i][2].z, 1 }, { faces[i][3].x, faces[i][3].y, faces[i][3].z, 1 } };

                //Move the face to the new location
                 movedPoints[i] = matrix.matMult(pointMatrix, position);
            }

            //Find max z value for each face
            double[,] maxZ = new double[6, 2];


            for (int i = 0; i < 6; i++)
            {
                maxZ[i, 1] = i;
                maxZ[i,0] = (movedPoints[i][0, 2]+movedPoints[i][1, 2]+movedPoints[i][2, 2]+movedPoints[i][3, 2]);
                for (int j = 1; j < 4; j++)
                {
                    if (movedPoints[i][j, 2] > maxZ[i,0]) maxZ[i,0] = movedPoints[i][j, 2];
                }
            }

            //Bubble sort maxZ
            for (int i = 0; i < 5; i++)
            {
                for (int j = i; j < 5; j++)
                {
                    if (maxZ[j, 0] > maxZ[j + 1, 0])
                    {
                        double temp = maxZ[j, 0];
                        maxZ[j, 0] = maxZ[j + 1, 0];
                        maxZ[j + 1, 0] = temp;
                        temp = maxZ[j, 1];
                        maxZ[j, 1] = maxZ[j + 1, 1];
                        maxZ[j + 1, 1] = temp;
                    }
                }
            }


            for(int i=5; i>2; i--){
                //Project the face onto 2D
                Point[] movedFace = projectFace(movedPoints[(int)maxZ[i, 1]], 5000);

                //Draw the face on the screen
                Graphics g = picbox1.CreateGraphics();

                //Get the index of one of the front faces
                int k = (int)maxZ[i, 1];

                Color fc = faceColors[k];
                


                //vector v1 = p2 - p1
                vector3D v1 = new vector3D(movedPoints[k][1,0] - movedPoints[k][0,0],movedPoints[k][1,1] - movedPoints[k][0,1],movedPoints[k][1,2]- movedPoints[k][0,2]);
                
                //vector v2 = p3 - p1
                vector3D v2 = new vector3D(movedPoints[k][2,0] - movedPoints[k][0,0],movedPoints[k][2,1] - movedPoints[k][0,1],movedPoints[k][2,2]- movedPoints[k][0,2]);

                //Normal vector N = v1 x v2
                vector3D N = v2.cross(v1);
                 
                //Get the midpoint of the face
                double midX=0, midY=0, midZ=0;
                for (int j=0; j<4; j++) { 
                    midX += movedPoints[k][j,0]; 
                    midY += movedPoints[k][j,1];
                    midZ += movedPoints[k][j,2];
                }  //End for
                midX/=4; midY/=4; midZ/=4;

                //Form the vector from the point light source to the center of the polygon
                vector3D lightVector = new vector3D(Light.x - midX, Light.y - midY, Light.z - midZ);

                double angle = Math.Abs(N.getAngle(lightVector));
                double multiplier;

                //Calculate the multiplier
                if (angle <= Math.PI/2 ) multiplier = (Math.PI/2 - angle)/(Math.PI/2);
                else multiplier = 0;

       
                //Get the color
                Color c = Color.FromArgb(
                    (byte)(faceColors[(int)maxZ[i,1]].R * multiplier),
                    (byte)(faceColors[(int)maxZ[i,1]].G * multiplier),
                    (byte)(faceColors[(int)maxZ[i,1]].B * multiplier));
                                   
                Brush b = new SolidBrush(c);

                g.FillPolygon(b, movedFace);
            }
        }

        //hides the graphics object in the PictureBox "picbox1"
        public void hide(PictureBox picbox1)
        {
            visible = false;

            Brush b = new SolidBrush(picbox1.BackColor);
            //Loop through each face
            for (int i = 0; i < 6; i++)
            {
                //Create a matrix of the original points for the edge
                double[,] pointMatrix = { { faces[i][0].x, faces[i][0].y, faces[i][0].z, 1 }, { faces[i][1].x, faces[i][1].y, faces[i][1].z, 1 }, { faces[i][2].x, faces[i][2].y, faces[i][2].z, 1 }, { faces[i][3].x, faces[i][3].y, faces[i][3].z, 1 } };

                //Move the edges to the new location
                double[,] movedPoints = matrix.matMult(pointMatrix, position);

                Point[] movedFace = projectFace(movedPoints, 5000);
                Graphics g = picbox1.CreateGraphics();

                g.FillPolygon(b, movedFace);
            }
        }


        Point[] projectFace(double[,] face, double d)
        {
            Point[] pface = new Point[4];
            pface[0].X = (int)(face[0, 0] * d / (d - face[0,2]));
            pface[0].Y = (int)(face[0, 1] * d / (d - face[0,2]));
            pface[1].X = (int)(face[1, 0] * d / (d - face[1, 2]));
            pface[1].Y = (int)(face[1, 1] * d / (d - face[1, 2]));
            pface[2].X = (int)(face[2, 0] * d / (d - face[2, 2]));
            pface[2].Y = (int)(face[2, 1] * d / (d - face[2, 2]));
            pface[3].X = (int)(face[3, 0] * d / (d - face[3, 2]));
            pface[3].Y = (int)(face[3, 1] * d / (d - face[3, 2]));
            return pface;
        }

   }//************* End class cube





    public class vector2D
    {
        public double x, y;

        //Constructors
        public vector2D() { x = 0; y = 0; }
        public vector2D(double x1, double y1) { x = x1; y = y1; }

        public double dot(vector2D v) { return x * v.x + y * v.y; }

        public double magnitude() { return Math.Sqrt(this.dot(this)); }

        public double getAngle(vector2D v)
        {
            return Math.Acos(this.dot(v) / (this.magnitude() * v.magnitude()));
        }
    }


    public class vector3D
    {
        public double x, y, z;

        //Constructors
        public vector3D() { x = 0; y = 0; z=0; }
        public vector3D(double x1, double y1, double z1) { x = x1; y = y1; z = z1;}

        public double dot(vector3D v) { return x * v.x + y * v.y + z * v.z; }

        public double magnitude() { return Math.Sqrt(this.dot(this)); }

        public vector3D cross(vector3D v)
        {
            return new vector3D(this.y * v.z - this.z * v.y, this.z * v.x - this.x * v.z, this.x * v.y - this.y * v.x);
        }

        public double getAngle(vector3D v)
        {
            return Math.Acos(this.dot(v) / (this.magnitude() * v.magnitude()));
        }
    }

    //********************************************************************************************
    //Used to draw a line with the DDA algorithm (or maybe others!)
    public class lines
    {
        // The "digital differential analyzer" or DDA method of drawing lines
        public static void DDA(int x1, int y1, int xk, int yk, PictureBox p1, Color c)
        {

            double m;
            bool slopeBig = false;

            //Get the current bitmap from the picturebox
            Bitmap canvas = (Bitmap)p1.Image;

            if (Math.Abs(yk - y1) >= Math.Abs(xk - x1)) { m = (xk - x1) / (double)(yk - y1); slopeBig = true; }
            else m = (yk - y1) / (double)(xk - x1);

            double realY = y1;
            double realX = x1;

            //Turn on the pixel at point (x1,y1) - the first point on the line
            if (x1 >= 0 && x1 < p1.Width && y1 >= 0 && y1 < p1.Height)
                canvas.SetPixel(x1, y1, c);

            //Case where the slope is between -1 and 1
            if (!slopeBig)
            {
                if (x1 > xk) { int temp = x1; x1 = xk; xk = temp; temp = y1; y1 = yk; yk = temp; realY = y1; }
                for (int i = x1 + 1; i <= xk; i++)
                {
                    //Add the slope to the actual y coordinate on the line and then round off and plot
                    realY = realY + m;
                    int y = (int)Math.Round(realY);
                    if (i >= 0 && i < p1.Width && y >= 0 && y < p1.Height)
                        canvas.SetPixel(i, y, c);
                }
            }
            else
            {   //Case where slope is >1 or <-1
                if (y1 > yk) { int temp = x1; x1 = xk; xk = temp; temp = y1; y1 = yk; yk = temp; realX = x1; }
                for (int i = y1 + 1; i <= yk; i++)
                {
                    //Add the slope to the actual y coordinate on the line and then round off and plot
                    realX = realX + m;
                    int x = (int)Math.Round(realX);
                    if (x >= 0 && x < p1.Width && i >= 0 && i < p1.Height)
                        canvas.SetPixel(x, i, c);
                }
            }
            //Show the canvas back in the picturebox
            p1.Image = canvas;
        }//end DDA
    }//end class lines

    public class matrix
    {
        public static double[,] matMult(double[,] x, double[,] y)
        {
            //Make sure you can multiply the matrices
            int xColumns = x.GetLength(1);
            int yRows = y.GetLength(0);

            if (xColumns != yRows) return null;

            //Get the dimesions of the result
            int xRows = x.GetLength(0);
            int yColumns = y.GetLength(1);

            //Create a matrix for the result
            double[,] result = new double[xRows, yColumns];


            //Multiply the matrices
            for (int i = 0; i < xRows; i++)
                    for (int j = 0; j < yColumns; j++)
                        for (int k = 0; k < xColumns; k++) result[i, j] += x[i, k] * y[k, j];
            return result;
        }//end matMult
    }//end matrix class
}//end namespace
