
def retrieve_prime(n, upper_known_bits, number_of_bits):
    """
    Based on Coppersmith Method - utilizes LLL reduction
    """
    print("[2] Retrieving prime number with LLL reduction technique...")

    X = 2^(number_of_bits)

    print(f"\t Definng upper bound (X) as: 2^{number_of_bits}")
    print("\t Creating matrix: [[X^2, X*upper_known_bits,0], [0,X,upper_known_bits],[0,0,n]]")

    M = matrix( [[X^2, X*upper_known_bits,0], [0,X,upper_known_bits],[0,0,n]] )

    print("\t Performing LLL reduction on the matrix")
    M_LLL = M.LLL()
    print("\t Defining polynomial g(x) from LLL-reduced matrix (M'): g(x) = M'[0][0]*x^2/X^2 + M'[0][1]*x/X + M'[0][2]")
    Q = M_LLL[0][0]*x^2/X^2+M_LLL[0][1]*x/X + M_LLL[0][2]
    print("\t Adding known bits (a) to root of g(x) (x_0) such: p = a + x_0")
    print(f"\t Retrieved first prime number (p): {upper_known_bits + Q.roots(ring=ZZ)[0][0]}")

    p = upper_known_bits + Q.roots(ring=ZZ)[0][0]
    q = n / p

    print(f"\t Retrieved second prime number (q): {q}\n")
    return p,q

def eulers_totient(p,q):
    return (p-1) * (q-1)

def calculate_private_component(e,p,q, phi):
    return inverse_mod(e,phi)

def decrypt(ciphertext, p,q,e,n):
    print("[3] Trying to decrypt ciphertext...")

    phi = eulers_totient(p,q)
    print(f"\t Calculated Euler's totient (phi): {phi}")
    
    d = calculate_private_component(e,p,q,phi)
    print(f"\t Calculated private component (d): {d}")
    pt  = pow(ciphertext,d,n)
    print(f"\t Recovered ciphertext: {hex(pt)}")
    return pt

def generate_example(plaintext, number_of_bits):
    print("[1] Generating example...")
    p = random_prime(2^512)
    q = random_prime(2^512)
    n = p * q
    e = 65537
    ct = plaintext^e % n

    print(f"\t p: {p}")
    print(f"\t q: {q}")
    print(f"\t n = p * q = {n}")
    print(f"\t e: {e}")
    print(f"\t CT: {ct}\n")


    return p - (p % 2 ^ number_of_bits), n, ct


N_bits = 10
plaintext = 0xdeadbeef

print(f"[0] Parameters")
print(f"\t PT: {hex(plaintext)}")
print(f"\t Number of known bits: {N_bits}\n")

a,n,ct = generate_example(plaintext, N_bits)

print(f"partially_knwon_prime (p): {a}\n")

possible_p, possible_q = retrieve_prime(n,a,N_bits)

pt = decrypt(ct,possible_p,possible_q,65537,n)

assert pt == plaintext
