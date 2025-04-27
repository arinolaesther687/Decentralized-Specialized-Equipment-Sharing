;; Owner Verification Contract
;; Validates legitimate equipment holders

(define-data-var admin principal tx-sender)

;; Map to store verified equipment owners
(define-map verified-owners principal bool)

;; Error codes
(define-constant err-not-admin (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-verified (err u102))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Verify an owner
(define-public (verify-owner (owner principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (asserts! (is-none (map-get? verified-owners owner)) err-already-verified)
    (ok (map-set verified-owners owner true))))

;; Revoke verification
(define-public (revoke-verification (owner principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (asserts! (is-some (map-get? verified-owners owner)) err-not-verified)
    (ok (map-delete verified-owners owner))))

;; Check if an owner is verified
(define-read-only (is-verified-owner (owner principal))
  (default-to false (map-get? verified-owners owner)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (ok (var-set admin new-admin))))
