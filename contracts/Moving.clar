;; clarity-problem-solver.clar
;; Short & unique Clarity contract for Google Clarity Web3

(define-data-var project-count uint u0)

(define-map projects ((id uint))
  ((owner principal)
   (title (string-ascii 50))
   (problem (string-ascii 80))
   (solution (string-ascii 80))
   (status (string-ascii 15))))

;; Create a new project with a defined problem
(define-public (create-project (title (string-ascii 50)) (problem (string-ascii 80)))
  (let ((id (var-get project-count)))
    (begin
      (map-set projects id
        ((owner tx-sender)
         (title title)
         (problem problem)
         (solution "")
         (status "submitted")))
      (var-set project-count (+ id u1))
      (ok id)
    )
  )
)

;; Submit a solution for an existing project
(define-public (solve-problem (id uint) (solution (string-ascii 80)))
  (match (map-get? projects id)
    project
      (begin
        (map-set projects id
          ((owner (get owner project))
           (title (get title project))
           (problem (get problem project))
           (solution solution)
           (status "solved")))
        (ok "Problem solved successfully")
      )
    (err u1) ;; project not found
  )
)

;; Obtain a contract once the project is solved
(define-public (obtain-contract (id uint))
  (match (map-get? projects id)
    project
      (if (is-eq (get status project) "solved")
          (begin
            (map-set projects id
              ((owner (get owner project))
               (title (get title project))
               (problem (get problem project))
               (solution (get solution project))
               (status "contracted")))
            (ok "Contract obtained successfully")
          )
          (err u2) ;; must be solved first
      )
    (err u3) ;; project not found
  )
)

;; View project details
(define-public (view-project (id uint))
  (match (map-get? projects id)
    project (ok project)
    (err u4)
  )
)
