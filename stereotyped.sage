def generate_example(plaintext ,e=3):
    print("[1] Generating example...")
    while True:
      p = random_prime(2^512)
      q = random_prime(2^512)
      n = p * q
      if (((p-1) * (q-1)) % e) != 0:
        break
  

    ct = plaintext^e % n

    print(f"\t p: {p}")
    print(f"\t q: {q}")
    print(f"\t n = p * q = {n}")
    print(f"\t e: {e}")
    print(f"\t CT: {ct}\n")


    return n, ct


def retrieve_plaintext(partial_pt, n, upper_bound, ciphertext):
    print("[2] Retrieving ciphertext with Howgrave-Graham...")


    print(f"\t Defining upper bound (X) as: {upper_bound}")
    print("\t Creating matrix: [[X^3, 3*X^2*partial_pt, 3*X*partial_pt^2, partial_pt^3-ciphertext], [0,n*X^2,0,0], [0,0,n*X,0],[0,0,0,n]]")

    X =upper_bound
    M = matrix( [[X^3, 3*X^2*partial_pt, 3*X*partial_pt^2, partial_pt^3-ciphertext], [0,n*X^2,0,0], [0,0,n*X,0],[0,0,0,n]] )
    print("\t Performing LLL reduction on the matrix")
    M_LLL = M.LLL()
    print("\t Defining polynomial g(x) from LLL-reduced matrix (M'): g(x) = M'[0][0]*x^3/X^3 + M'[0][1]*x^2/X^2 + M'[0][2]*x/X + M'[0][3]")
    Q = M_LLL[0][0]*x^3/X^3+M_LLL[0][1]*x^2/X^2+M_LLL[0][2]*x/X + M_LLL[0][3]
    

    retrieved_pt = Q.roots(ring=ZZ)[0][0]
  

    print(f"\t Retrieved rest of plaintext: {retrieved_pt.str(base=36)}\n")
    return retrieved_pt



plaintext = Integer("yourpasswordispassword",36)
partially_known_pt = Integer("yourpasswordis00000000",36)

print(f"[0] Parameters")
print(f"\t Original PT: {plaintext.str(base=36)}")
print(f"\t Fragment of PT known by attacker: {partially_known_pt.str(base=36)}")


n,ct = generate_example(plaintext)


upper_bound = Integer("zzzzzzzz", 36) # 'z' is the highest value in alphabet 0-9a-z

retrieve_plaintext(partially_known_pt, n, upper_bound, ct)
