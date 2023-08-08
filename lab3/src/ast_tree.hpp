#ifndef ASTTREE_H
#define ASTTREE_H

#include <algorithm> //std::next
#include <sstream> //std::stringstream
#include <memory>
#include <list>
#include <string>
#include <type_traits>
#include <utility>


namespace AstTree {

// static int GlobalIdForASTNode = 0;

// template <typename NodeType, typename = typename std::enable_if< std::is_enum<NodeType>::value >::type>
// class AstNode: public std::enable_shared_from_this<AstNode<NodeType>> {
//     public:
//         using Sharedptr = std::shared_ptr<AstNode<NodeType>>;
//         using Weakptr = std::weak_ptr<AstNode<NodeType>>;

//         AstNode()
//             : AstNode(static_cast<NodeType>(0), std::string())
//         {}

//         AstNode(NodeType type, std::string name = "")
//             : type_(std::move(type))
//             , name_(std::move(name))
//             , parent_(Sharedptr())
//         {
//             GlobalIdForASTNode++;
//         }


//         Sharedptr 

//     private:
//         NodeType type_;
//         std::list<Sharedptr> childnodes_;
//         Weakptr parent_;
//         std::string name_;

// };

enum NodeType{
    Prog, Assign, FuncCall, BOP, Elem
};

class AstNode: public std::enable_shared_from_this<AstNode>{
    public:
        using Sharedptr = std::shared_ptr<AstNode>;
        using Weakptr = std::weak_ptr<AstNode>;

        AstNode(NodeType type, std::string name)
            :type_(std::move(type)),
            name_(std::move(name))
        {}

        ~AstNode()
        {}


        void create_child(Sharedptr child){
            auto self = this->shared_from_this();
            child->setParent(self);
            childnodes_.emplace_back(std::move(child));
        }


        static Sharedptr CreateInstance(NodeType type, std::string name, const Sharedptr &child1, const Sharedptr &child2){
            const Sharedptr inst(std::make_shared<AstNode>(type, name));
            if(child1){
                inst->create_child(child1);
            }
            if(child2){
                inst->create_child(child2);
            }
        }

        void setParent(const Weakptr &parent){
            parent_ = parent;
        }

        NodeType getType(){
            return type_;
        }

        std::list<Sharedptr> getChilds(){
            return childnodes_;
        }

        std::string getName(){
            return name_;
        }
    
    private:
        NodeType type_;
        std::list<Sharedptr> childnodes_;
        Weakptr parent_;
        std::string name_;

}; 
}
#endif
