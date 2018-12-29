 import UIKit

final class TodoViewController: UIViewController {

    private let viewModel: TodoViewModel
    private let alert = UIAlertController(title: "Add todo", message: nil, preferredStyle: .alert)
    private let tableView = UITableView()

    init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        title = "Todos"
        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = addButton

        configureAlert()
    }

    private func configureAlert() {
        alert.addTextField { tf in
            tf.placeholder = "Todo text"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            self?.handleAdd()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak self] _ in
            self?.alert.dismiss(animated: true, completion: nil)

        }))
    }

    @objc private func addButtonClicked() {
        present(alert, animated: true, completion: nil)
    }

    private func handleAdd() {
        guard let todoText = alert.textFields?.first?.text else { return }
        viewModel.addTodo(todo: Todo(value: ["title": todoText]))
    }
}

extension TodoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeue(for: indexPath)
        let item = viewModel.itemForRow(at: indexPath)
        cell.textLabel?.text = "Id: \(idToString(id: item.id) ?? "nil")  Title: \(item.title)"
        return cell
    }

    private func idToString(id: Int?) -> String? {
        guard let id = id else { return nil }
        return String(id)
    }
}

 extension TodoViewController: TodoViewModelView {
     func reloadView() {
         tableView.reloadData()
     }
 }
