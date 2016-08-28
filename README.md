# Capacitive-Loading

Overall Description: Phi distribution

The initial commit correspod to Hyperthermia_Lung(v1_2_8).TEX

The boundary conditions for the top down bolus line and the bolus point 

have been modified to somewhat wierd BC, e.g. half of the BC are the same 

as bolus face; half of the BC are the same as air face.

As for the air face, air line and air point: 

this version applied the BC as E_z = 0;

0826: For the current version, though the code work somehow, 

but the boundary conditions on the air box still need to be 

retrimmed. Here, I apply continuous bar(D) to X-edge, Y-edge and Z-edge.

However, the bottom region need to be modified to this kind of BC.

Furthermore, the BC on the top four edge point was: 

p0 = (p1 + p2 + p3) / 3

TO LISTS:
1. Give a short notes on how I implement the BC so far.
2. Implement the bottom air region.
3. Handmade the code for conjugate gradient method.
4. Compare it using least mean square error method.

Since the current BC will restrict the boundary to zero-voltage, 
the air layer are needed to be prolonged.
