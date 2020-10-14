# Rollout Trait Design  

## Current design
The problem with the current flagger design is that it wants to be strictly GitOps compatible. Thus, it 
cannot touch the image related fields in the "target" object. That's why it has to create a "primary" deployment
and treat the "target" as the "canary" while doing the rollout. It finally "promotes" the primary 
by copying everything from the "canary" to the "primary" after it 's done.

We don't need to stick to that scheme, but we face a similar problem as our component/workload controller
will constantly reconcile the target component too. The only way is to pin the component to a specific
revision in the application configuration. The user then can modify the component and that can be automatically
picked up by the rollout trait. User can also explicitly add the revision number to the rollout trait to control
the rollout version manually.

## Proposed design
- Add a new "meshProvider" type "OAM", the scheduler will automatically set the meshProvider as the "routeTrait" implementation
which is SMI for now.
- OAM can fill the workloadRef to the `sourceRef` automatically. This will point the trait to the workload 
which has its "componentRevisionName" in its label.
- Write an OAM resource controller in the flagger that works with the podSpecWorkload/containerizedWorkload/Deployment
    - We need to use the workload itself as the primary, and the "target" as the canary   
    - Find the latest component revision as the canary if the user didn't explicitly spell out the revisionName
    - The Initialize function will create the workload corresponding to the revisionName
    - The rest 
    - The Promote function will copy the canary (target) spec back to primary (source) and change its revisionName label.
     OAM runtime should not overwrite the workloads that has a 
- It seems that we don't need an OAM specific router (even if the service/routing name is a bit mis-matched) 
- Remove all the hard coded string literal "primary" from the scheduler.go file
- We need a way to translate the status of the flagger trait status back to the rollout output 